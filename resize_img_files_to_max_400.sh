#!/bin/bash

# Navigate to the directory containing your images
cd /home/lemon/code/html/jo-rebrand/img/

# Loop through each image file
for file in *.jpg *.JPG *.png *.gif; do
    # Check if the file exists and is a regular file
    if [ -f "$file" ]; then
        # Resize the image using ImageMagick's convert command
        convert "$file" -resize '400x>' "$file"
        echo "Resized $file"
    fi
done

