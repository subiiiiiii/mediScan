import cv2
import easyocr
import matplotlib.pyplot as plt
import numpy as np

# Function to merge bounding boxes horizontally
def merge_boxes_by_row(text_, row_threshold=10):
    rows = []
    current_row = []
    
    for box in text_:
        if len(current_row) == 0:
            current_row.append(box)
        else:
            # Check if the current box is in the same row by comparing y-coordinates
            prev_y = current_row[-1][0][0][1]  # y-coordinate of the last box in the current row
            curr_y = box[0][0][1]  # y-coordinate of the current box
            
            # If the y-coordinate difference is small enough, consider it the same row
            if abs(curr_y - prev_y) < row_threshold:
                current_row.append(box)
            else:
                rows.append(current_row)
                current_row = [box]
    
    # Append the last row
    if current_row:
        rows.append(current_row)
    
    return rows

# read image
image_path = 'data/test1.png'
img = cv2.imread(image_path)

# instance text detector
reader = easyocr.Reader(['en'], gpu=False)

# detect text on image
text_ = reader.readtext(img)

# Merge text boxes that are close in the vertical direction (same row)
rows = merge_boxes_by_row(text_, row_threshold=10)

# Draw bbox and text for each row
for row in rows:
    # Get the minimum and maximum x and y coordinates for the entire row
    min_x = min([box[0][0][0] for box in row])
    max_x = max([box[0][2][0] for box in row])
    min_y = min([box[0][0][1] for box in row])
    max_y = max([box[0][2][1] for box in row])
    
    # Draw a single bounding box for the entire row
    cv2.rectangle(img, (int(min_x), int(min_y)), (int(max_x), int(max_y)), (0, 255, 0), 2)

     # Combine the text from all the boxes in the row
    text = " ".join([t[1] for t in row])
    
    # Print the combined text to the console
    print(f"{text}")

    # Draw the combined text at the start of the bounding box
    cv2.putText(img, text, (int(min_x), int(min_y) - 10), cv2.FONT_HERSHEY_COMPLEX, 0.65, (255, 0, 0), 2)


# Display the result
plt.imshow(cv2.cvtColor(img, cv2.COLOR_BGR2RGB))
plt.axis('off')  # Hide axis
plt.show()