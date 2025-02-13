#!/bin/bash

# Check if a root directory is provided
if [ $# -eq 0 ]; then
    echo "Please provide the root directory as an argument."
    exit 1
fi

# Root directory
root_dir="$1"

# Check if the root directory exists
if [ ! -d "$root_dir" ]; then
    echo "The provided root directory does not exist."
    exit 1
fi

# Iterate over all subdirectories in the root directory
for dir in "$root_dir"/*; do
    if [ -d "$dir" ]; then
        # Extract the folder name
        folder_name=$(basename "$dir")
        
        # Create the results directory
        results_dir="${dir}_results"
        mkdir -p "$results_dir"
        
        # Run the Python script
        python mono/tools/test_scale_cano.py \
            'mono/configs/HourglassDecoder/vit.raft5.large.py' \
            --load-from ./weight/metric_depth_vit_large_800k.pth \
            --test_data_path "$dir" \
            --show-dir "$results_dir" \
            --exclude_substring 'sam_mask' \
            --launcher None
        
        echo "Processed: $folder_name"
    fi
done

echo "All subdirectories processed."
