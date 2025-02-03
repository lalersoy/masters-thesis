#!/bin/bash
# Parallel fMRI Preprocessing using SLURM Job Scheduler
% Author: Deniz Lal Ersoy
% Email: ersoydenizlal@gmail.com
% Date: 2023-06-23
#
# Description:
# This script submits separate SLURM jobs for each subject in the dataset.
# It runs SPM12 in standalone mode using MATLABR2022b.
# Each subject’s preprocessing job is submitted independently for parallel execution.
#
# Dependencies:
# - SLURM job scheduler
# - MATLAB Runtime (R2022b)
# - SPM12 standalone

# Define paths
DATA_DIR="$HOME/derivatives/spm_chopstick"
SPM="$HOME/matlab/tools/standalone_v7771_R2022b/run_spm12.sh"
MATLAB_RUNTIME="/opt/matlab/R2022b"

# Navigate to data directory
cd "$DATA_DIR" || { echo "Data directory not found!"; exit 1; }

# Create logs directory if it doesn't exist
mkdir -p logs

# Loop over all subject folders and submit jobs
for subject in sub-* ; do
    JOB_FILE="preprocessing_job_${subject}.txt"
    
    # Create a new SLURM job script
    echo "#!/bin/bash" > "$JOB_FILE"
    echo "#SBATCH --job-name=Chopstick_$subject" >> "$JOB_FILE"
    echo "#SBATCH --time=02:00:00" >> "$JOB_FILE"
    echo "#SBATCH --mem=2GB"  >> "$JOB_FILE"
    echo "#SBATCH --output=$DATA_DIR/logs/slurm-%j.out" >> "$JOB_FILE"

    # Run SPM12 with the preprocessing batch for the current subject
    echo "$SPM $MATLAB_RUNTIME run $DATA_DIR/$subject/*_fmri_preprocessing_chopstick.mat" >> "$JOB_FILE"

    # Submit the job to SLURM
    sbatch "$JOB_FILE"

    # Cleanup temporary job file
    rm -f "$JOB_FILE"
    
    echo "Job for $subject submitted."
done

echo "All preprocessing jobs submitted successfully."
