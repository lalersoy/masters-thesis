#!/bin/bash
# Parallel Processing of GLM Analysis using SLURM
#
# Author: Deniz Lal Ersoy
# Email: ersoydenizlal@gmail.com
# Date: 2024-04-30
#
# Description:
# This script automates the parallel execution of GLM analysis for fMRI data.
# It generates batch job scripts for each subject and session and submits them to SLURM.
#
# Dependencies:
# - SLURM job scheduler
# - MATLAB Standalone SPM12
#
# Usage:
# Run the script in a computing cluster environment with SLURM support.

# Define paths
data_dir="$HOME/path/to/derivatives/fmri_data"
spm_exec="$HOME/path/to/matlab/tools/spm12/run_spm12.sh"
log_dir="$data_dir/logs"

# Ensure log directory exists
mkdir -p "$log_dir"

# Navigate to data directory
cd "$data_dir" || { echo "Error: Cannot access $data_dir"; exit 1; }

# Iterate over subjects
for subject in sub-*; do
    sub_dir="$data_dir/${subject}"
    cd "$sub_dir" || continue
    
    # Iterate over sessions
    for ses_id in ses-*; do
        ses_dir="$sub_dir/${ses_id}"
        glm_dir="$ses_dir/glm_roi_residuals"
        glm_file="$glm_dir/${subject}_${ses_id}_glm_roi_residuals.mat"
        
        # Generate SLURM job script
        job_script="$ses_dir/glm_job_${subject}_${ses_id}.sh"
        cat <<EOT > "$job_script"
#!/bin/bash
#SBATCH --job-name=ROI_${subject}
#SBATCH --time=02:00:00
#SBATCH --mem=4GB
#SBATCH --output=$log_dir/slurm-%j.out

$spm_exec /opt/matlab/R2022b run "$glm_file"
EOT
        
        # Submit job and clean up
        sbatch "$job_script"
    done
done

echo "All GLM jobs submitted."