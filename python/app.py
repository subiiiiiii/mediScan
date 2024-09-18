from flask import Flask, request, jsonify
from flask_cors import CORS
import cv2
import easyocr
import numpy as np

app = Flask(__name__)
CORS(app)
reader = easyocr.Reader(['en'], gpu=False)

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

    return jsonify(result)

if __name__ == '__main__':
    app.run(debug=True)
