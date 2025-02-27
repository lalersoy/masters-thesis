
# Thesis: A Longitudinal fMRI Study of Chopstick Skill Acquisiton 

##  Overview
This repository contains scripts and data processing workflows for my thesis on functional reorganization in the brain across a 10-week period of motor skill learning. The project involves preprocessing, statistical modeling (GLM), and machine learning-based classification of fMRI data using **The Decoding Toolbox (TDT)**.

##  Abstract
Despite significant evidence supporting the existence of internal models for tool transformations in the cerebellum, little research has been done to identify the acquisition process and the contributing regions and processes. Tool use studies suggest the collaboration of a manipulation left-lateralized system, storing multisensory and motor memories of tool actions, with a sensorimotor production system linked to internal models. This study aimed to explore the acquisition of an internal model for chopstick use through longitudinal whole-brain searchlight multivariate pattern analysis (MVPA). Functional brain reorganization was tracked over a 10-week period, with task-fMRI measurements taken at pre-training, mid-training (two weeks in), and post-training. Participants alternated between using their right hands and chopsticks in a fMRI compatible setup. Analysis revealed regions exhibiting a quadratic change, peaking in chopstick-specific information processing at mid-training, and others showing a linear increase from pre to post-training. These findings suggest that regions with quadratic changes are crucial for learning internal representations of chopstick dynamics, modulating the encoding of these multisensory and motor memories in other regions. The study underscores a transition from feedback-based error corrections to a reliance on these internal models for feedforward control.

## Repository Structure
```bash
masters-thesis
├── code/
│   ├── preprocessing/         
│   │   ├── preprocessing_chopstick.m   # Performs preprocessing of fMRI data using SPM12
│   │   ├── run_chopstick_preproc.m           
│   ├── glm/                  
│   │   ├── GLM_mvpa.m   # Sets up and runs GLM using SPM12
│   │   ├── event_extraction.m   # Loads event timing from subject TSV files, extracts motion regressors, computes framewise displacement 
│   ├── mvpa/             
│   │   ├── crossvalidation.m   # Performs searchlight-based decoding analysis using TDT 
│   │   ├── anova.m # Performs a repeated measures ANOVA with factor Time
│   │   ├── run_anova.m 
│   ├── log_processing/        # Scripts for transforming log files into usable formats
│   │   ├── chopstick_onsettimes.pl   
│   │   ├── txt_to_tsv.sh  
│   ├── parallel_processing/   # SLURM-based batch job submission scripts
│   │   ├── preprocessing_job.sh   
│   │   ├── glm_slurm_job.sh             
│   │   ├── crossvalidation_job.sh      
│   ├── behavioral_analysis/  
│   │   ├── betweengroup_analysis.R # Group-level comparison between control and experimental groups 
│   │   ├── withinsubject_analysis.R  # Mixed-effects models for within-subject longitudinal analysis
│   ├── visualizations/  # Behavioral plots (LaTeX)
│   │   ├── betweengroup_behavioral.png 
│   │   ├── withingsubject_behavioral.png  
├── README.md                 
```

## Usage
### **1. TSV Creation**
Convert log files into text format using Perl:
```bash
perl code/log_processing/chopstick_onsettimes.pl logfile
```
Convert text files into TSV format using Bash:
```bash
bash code/log_processing/txt_to_tsv.sh
```

### **2. Preprocessing**
Run **run_chopstick_preproc.m** to preprocess fMRI data:
```matlab
preprocessing_chopstick('XXXXX')
```
Alternatively, submit a batch job for parallel preprocessing:
```bash
sbatch code/parallel_processing/preprocessing_job.sh
```

### **3. General Linear Model (GLM)**
Extract events from TSV files and prepare for GLM and run the GLM specification and estimation using **event_extraction.m**, where ses stands for session number:
```matlab
GLM_mvpa('XXXXX', 'ses-XX')
```
Or run parallel processing for GLM:
```bash
sbatch code/parallel_processing/glm_slurm_job.sh
```


### **4. MVPA with Support Vector Machines**
Execute searchlight-based MVPA analysis:
```matlab
crossvalidation('XXXXX', 'ses-XX')
```
Or run parallel processing for decoding:
```bash
sbatch code/parallel_processing/crossvalidation_job.sh
```

### **5. Repeated Measures ANOVA**
Execute ANOVA to test for linear and quadratic changes in decoding accuracy across 3 time points using **run_anova.m**:
```matlab
anova({'XXXXX', 'XXXXX',....}) # Subject IDs
```

### **6. Behavioral Analysis**
Run within-subject behavioral analysis:
```r
Rscript behavioral_analysis/within_subject_analysis.R
```
Run between-subject group comparison:
```r
Rscript behavioral_analysis/between_subject_analysis.R
```

##  References
- **SPM12:** https://www.fil.ion.ucl.ac.uk/spm/software/spm12/
- **The Decoding Toolbox (TDT):** https://sites.google.com/site/tdtdecodingtoolbox/
- **imcalc:** https://www.nitrc.org/projects/imcalc/

##  Acknowledgments
I am profoundly grateful to Prof. Simone Kühn, my primary supervisor, for welcoming me as an intern and providing invaluable guidance throughout my Master’s thesis. I would also like to express my gratitude to Prof. Felix Blankenburg for his co-supervision and interest in my work.
I owe special thanks to Maike Hille for helping me navigate the trickier parts of the researchand made everything seem manageable. This Master’s thesis is part of a bigger Staebchen project that she had designed and lead, and I am deeply grateful to her for that. 


