#!/bin/bash
# Convert .txt event logs into BIDS-compatible .tsv format
#
# Author: Deniz Lal Ersoy
# Email: ersoydenizlal@gmail.com
# Date: 2023-06-13
#
# Description:
# This script extracts event-related information from .txt files and converts it into
# a BIDS-compatible .tsv format for fMRI event modeling.
#
# Dependencies:
# - AWK (for tab-separated data processing)
#
# Usage:
# ./txt_to_tsv.sh

# Define data paths
data_path="/path/to/derivatives/processed_data"
txt_log_path="/path/to/logs/event_logs"

# Initialize array for subject IDs
ids=()

# Navigate to data directory
cd "$data_path" || { echo "Error: Could not access $data_path"; exit 1; }

# Extract subject IDs from directory names
for subject in sub-* ; do
    [ -d "${subject}" ] || continue  # Skip if not a directory
    ids+=("${subject:4:10}")  # Extract subject ID
done

echo "Processing subjects: ${ids[@]}"

# Loop through each subject and session
for id in "${ids[@]}"; do 
    ses_dir="$data_path/sub-${id}"
    cd "$ses_dir" || continue  # Skip if directory does not exist

    for ses in ses-* ; do 
        sesno="${ses:4:6}"
        tsv_file="$ses_dir/${ses}/func/sub-${id}_${ses}_task-events.tsv"
        txt_file="$txt_log_path/${id}_${sesno}_events.txt"
        
        if [ -e "$txt_file" ]; then
            echo "Generating: $tsv_file"
            
            # Create TSV file header
            awk 'BEGIN{ OFS="\t"; print "onset\tduration\ttrial_type"; }' > "$tsv_file"
            
            # Extract and reformat event information from .txt file
            awk -v OFS="\t" '{ 
                if ($2 == "1") $2="event_type_1";
                else if ($2 == "2") $2="event_type_2";
                else if ($2 == "3") $2="null";
                print $5, $7, $2;
            }' "$txt_file" >> "$tsv_file" 
        else
            echo "Warning: Source file not found - $txt_file"
        fi
    done
done

echo "TSV conversion complete!"