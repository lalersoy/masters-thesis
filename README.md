# masters-thesis
Master's Thesis 
# 📖 Thesis: A Longitudinal fMRI Study of Chopstick Skill Acquisiton 

## 🔍 Overview
This repository contains scripts and data processing workflows for my thesis on **Multivariate Pattern Analysis (MVPA) in Longitudinal fMRI Data using Support Vector Machines (SVM)**. The project involves preprocessing, statistical modeling (GLM), and machine learning-based classification using **The Decoding Toolbox (TDT)**.

## 📂 Repository Structure
```bash
📦 thesis-mvpa-fmri
├── code/
│   ├── preprocessing/         # fMRI preprocessing scripts (MATLAB, Bash)
│   ├── glm/                   # General Linear Model (GLM) specification & estimation
│   ├── mvpa/              # MVPA & SVM classification scripts
│   ├── log_processing/        # Scripts for transforming log files into usable formats
│   ├── parallel_processing/   # SLURM-based batch job submission scripts
│   │   ├── preprocessing_jobs.sh   # Parallel processing for preprocessing
│   │   ├── glm_jobs.sh             # Parallel processing for GLM
│   │   ├── decoding_jobs.sh        # Parallel processing for MVPA
├── README.md                  # This file
├── LICENSE                    # License file (MIT/GPL/etc.)
```

## 🚀 Usage
### **1. Preprocessing**
Run **preprocessing_chopstick.m** to preprocess fMRI data:
```matlab
preprocessing_chopstick('XXXXX')
```
Alternatively, submit a batch job for parallel preprocessing:
```bash
sbatch code/parallel_processing/preprocessing_job.sh
```

### **2. General Linear Model (GLM)**
Run the GLM specification and estimation:
```matlab
GLM_mvpa('XXXXX', 'ses-XX')
```
Or run parallel processing for GLM:
```bash
sbatch code/parallel_processing/glm_slurm_job.sh
```

### **3. MVPA with Support Vector Machines**
Execute searchlight-based MVPA analysis:
```matlab
crossvalidation('XXXXX', 'ses-XX')
```
Or run parallel processing for decoding:
```bash
sbatch code/parallel_processing/decoding_job.sh
```

## 📜 References
- **SPM12:** https://www.fil.ion.ucl.ac.uk/spm/software/spm12/
- **The Decoding Toolbox (TDT):** https://sites.google.com/site/tdtdecodingtoolbox/
- **imcalc:** https://www.nitrc.org/projects/imcalc/

## 🤝 Acknowledgments
I am profoundly grateful to Prof. Simone Kuehn, my primary supervisor, for welcoming me as an intern and providing invaluable guidance throughout my Master’s thesis. Her expertise and support have been fundamental to my academic development and the completion of this thesis. I would also like to express my gratitude to Prof. Felix Blankenburg for his co-supervision and interest in my work.
I owe special thanks to Maike Hille for helping me navigate the trickier parts of the researchand made everything seem manageable. This Master’s thesis is part of a bigger Staebchen project that she had designed and lead, and I am deeply grateful to her for that. 


