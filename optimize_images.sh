#!/bin/bash

# Define the assets folder
ASSETS_FOLDER="./assets/images"
OPTIMIZED_FOLDER="$ASSETS_FOLDER/optimized"

# Create the optimized folder if it doesn't exist
mkdir -p "$OPTIMIZED_FOLDER"

# Iterate through all images in the assets folder
find "$ASSETS_FOLDER" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \) | while read -r img; do
    echo "Processing $img..."

    # Get the file extension and file name without extension
    extension="${img##*.}"
    filename=$(basename "$img" | sed "s/\.[^.]*$//")

    # Get the relative path of the image
    relative_path="${img#$ASSETS_FOLDER/}"

    # Get the directory path of the image relative to the assets folder
    relative_dir=$(dirname "$relative_path")

    # Create the corresponding directory structure in the optimized folder
    mkdir -p "$OPTIMIZED_FOLDER/$relative_dir"

    # Define the output path for the optimized image
    optimized_img_path="$OPTIMIZED_FOLDER/$relative_dir/$filename.webp"

    # Check if WebP version already exists
    if [[ -f "$optimized_img_path" ]]; then
        echo "$img is already optimized. Skipping."
        continue
    fi

    echo "Optimizing $img..."

    # Convert to WebP format
    cwebp -q 80 "$img" -o "$optimized_img_path"

    # Resize image if it's larger than 1920x1080 (common full HD resolution)
    mogrify -path "$OPTIMIZED_FOLDER/$relative_dir" -resize '1920x1080>' "$img"

    # Compress original images based on type
    if [[ "$extension" == "jpg" || "$extension" == "jpeg" ]]; then
        jpegoptim --max=80 --strip-all "$OPTIMIZED_FOLDER/$relative_dir/$filename.$extension"
    elif [[ "$extension" == "png" ]]; then
        pngquant --force --ext .png --speed 1 "$OPTIMIZED_FOLDER/$relative_dir/$filename.png"
    fi

    echo "$img optimized and saved to $OPTIMIZED_FOLDER/$relative_dir"
done

echo "Image optimization completed!"
