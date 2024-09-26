from flask import Flask, request, jsonify
from flask_cors import CORS
import cv2
import easyocr
import numpy as np
from pymongo import MongoClient
import gridfs
from database import register_user, login_user  # Import your database functions

app = Flask(__name__)
CORS(app)
reader = easyocr.Reader(['en'], gpu=False)

# MongoDB setup
client = MongoClient('mongodb://localhost:27017/')  # Update the URI if necessary
db = client['mediScanDB']
fs = gridfs.GridFS(db)
ocr_collection = db['ocr_results']

def merge_boxes_by_row(text_, row_threshold=10):
    rows = []
    current_row = []
    
    for box in text_:
        if len(current_row) == 0:
            current_row.append(box)
        else:
            prev_y = current_row[-1][0][0][1]
            curr_y = box[0][0][1]
            if abs(curr_y - prev_y) < row_threshold:
                current_row.append(box)
            else:
                rows.append(current_row)
                current_row = [box]
    
    if current_row:
        rows.append(current_row)
    
    return rows

@app.route('/ocr', methods=['POST'])
def ocr():
    if 'file' not in request.files:
        return jsonify({'error': 'No file part'}), 400

    file = request.files['file']
    img = cv2.imdecode(np.frombuffer(file.read(), np.uint8), cv2.IMREAD_COLOR)
    text_ = reader.readtext(img)
    rows = merge_boxes_by_row(text_, row_threshold=10)

    result = []
    for row in rows:
        min_x = min([box[0][0][0] for box in row])
        max_x = max([box[0][2][0] for box in row])
        min_y = min([box[0][0][1] for box in row])
        max_y = max([box[0][2][1] for box in row])
        text = " ".join([t[1] for t in row])
        result.append({
            "bounding_box": [int(min_x), int(min_y), int(max_x), int(max_y)],
            "text": text
        })

    # Store the image and OCR result in MongoDB
    image_id = fs.put(file.read(), filename=file.filename, content_type=file.content_type)  # Store image in GridFS
    ocr_data = {
        "image_id": image_id,
        "ocr_result": result
    }
    ocr_collection.insert_one(ocr_data)  # Save OCR result and image reference in the collection

    return jsonify(result)

@app.route('/retrieve/<image_id>', methods=['GET'])
def retrieve_image_and_text(image_id):
    try:
        # Retrieve the OCR result and image from the database
        ocr_record = ocr_collection.find_one({"image_id": image_id})
        if ocr_record:
            image_data = fs.get(image_id).read()  # Retrieve image file from GridFS
            return jsonify({
                "ocr_result": ocr_record["ocr_result"],
                "image": image_data.decode('latin1')  # You may need to encode/decode image differently
            })
        else:
            return jsonify({'error': 'No data found for this image ID'}), 404
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/register', methods=['POST'])
def register():
    user_data = request.json 
    result = register_user(user_data)
    return jsonify(result)

@app.route('/login', methods=['POST'])
def login():
    login_data = request.json
    result, status_code = login_user(login_data)  # Get the result and status code separately
    return jsonify(result), status_code  # Return the response with the status code

if __name__ == '__main__':
    app.run(debug=True)
