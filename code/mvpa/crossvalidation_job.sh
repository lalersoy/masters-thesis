#!/bin/bash
# Parallel Processing of Searchlight Decoding using SLURM
#
# Author: Deniz Lal Ersoy
# Email: ersoydenizlal@gmail.com
# Date: 2024-05-21
#
# Description:
# This script automates the parallel execution of a searchlight decoding analysis
# using The Decoding Toolbox (TDT) in MATLAB. It generates batch job scripts for
# each subject and session and submits them to SLURM.
#
# Dependencies:
# - SLURM job scheduler
# - MATLAB with The Decoding Toolbox (TDT)
#
# Usage:
# Run this script on a computing cluster with SLURM support.

# Define paths
data_dir="$HOME/path/to/derivatives/fmri_data"
decoding_toolbox="$HOME/path/to/matlab/decoding_toolbox"
code_dir="$data_dir/code/glm_roi"

# Export decoding toolbox path
export decoding_toolbox

# Ensure log directory exists
log_dir="$data_dir/logs"
mkdir -p "$log_dir"

# Navigate to data directory
cd "$data_dir" || { echo "Error: Cannot access $data_dir"; exit 1; }

# Iterate over subjects
for subject in sub-*; do
    subj_id=${subject#sub-}  # Extract subject ID
    echo "Processing subject: $subj_id"
    subj_dir="$data_dir/$subject"
    cd "$subj_dir" || continue
    
    # Iterate over sessions
    for ses_id in ses-*; do
        echo "Submitting job for $subject $ses_id"
        
        job_script="$subj_dir/${ses_id}/decoding_job_${subj_id}_${ses_id}.sh"
        
        cat <<EOT > "$job_script"
#!/bin/bash
#SBATCH --job-name=Searchlight_$subject
#SBATCH --time=02:00:00
#SBATCH --mem=2GB
#SBATCH --output=$log_dir/slurm-%j.out

. /etc/profile
module load matlab/R2022b
matlab -r "addpath('$code_dir'); crossvalidation('$subj_id','$ses_id'); exit;"
EOT
        
        # Submit job
        sbatch "$job_script"
    done
    
    # Return to base directory
    cd "$data_dir" || exit

done

echo "All decoding jobs submitted."
