% Description: 
% This script performs a within-subject ANOVA analysis on MVPA decoding 
% difference accuracy maps across three session points. 
%   - **Session 1** (Pre-training)
%   - **Session 3** (Two weeks into training)
%   - **Session 7** (Post-training)
% It tests for:
%   - **Linear change**: A continuous increase or decrease over time (S1 → S3 → S7).
%   - **Quadratic change**: A peak at **Session 3** or a trough at **Session 3**, 
%     indicating a non-linear trend.
% 
% Author: Deniz Lal Ersoy
% Email: ersoydenizlal@gmail.com
% Date: 2024-05-12
% 
% Dependencies:
% - SPM12
%
% Usage:
%   anova({'XXXXX', 'XXXXX', 'XXXXX'}) # Subject IDs
%

function anova(experimental_group)

% Define base directories 
data_dir = '/path/to/derivatives/fmri_data/';
results_dir = fullfile(data_dir, 'thesis_results/multivariate/anova_server/');

% Initialize SPM batch
matlabbatch{1}.spm.stats.factorial_design.dir = {results_dir};

% Loop over experimental subjects
for i = 1:numel(experimental_group)
    subj_dir = fullfile(data_dir, ['sub-', experimental_group{i}]);

    % Paths to difference accuracy maps for each session
    ses_01 = fullfile(subj_dir, 'ses-01/decoding/tdt_searchlight/diff_accuracy_map.nii');  % Pre-training, Session 1
    ses_03 = fullfile(subj_dir, 'ses-03/decoding/tdt_searchlight/diff_accuracy_map.nii');  % Mid-training (2 weeks in), Session 3
    ses_07 = fullfile(subj_dir, 'ses-07/decoding/tdt_searchlight/diff_accuracy_map.nii');  % Post-training, Session 7

    % Assign sessions to the ANOVA model
    matlabbatch{1}.spm.stats.factorial_design.des.anovaw.fsubject(i).scans = {ses_01; ses_03; ses_07};
    matlabbatch{1}.spm.stats.factorial_design.des.anovaw.fsubject(i).conds = [1; 2; 3]; % Corresponding session labels
end 

% ANOVA Model Specification
matlabbatch{1}.spm.stats.factorial_design.des.anovaw.dept = 1;
matlabbatch{1}.spm.stats.factorial_design.des.anovaw.variance = 1;
matlabbatch{1}.spm.stats.factorial_design.des.anovaw.gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.anovaw.ancova = 0;
matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;

% Model Estimation
matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('Factorial design specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;

% Contrast Specification
matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));

% **Linear Change Contrast**: Detects an increase or decrease across time (S1 → S3 → S7)
matlabbatch{3}.spm.stats.con.consess{1}.fcon.name = 'linear change';
matlabbatch{3}.spm.stats.con.consess{1}.fcon.weights = [1 0 -1]; % Linear contrast (increase/decrease)
matlabbatch{3}.spm.stats.con.consess{1}.fcon.sessrep = 'none';

% **Quadratic Change Contrast**: Identifies a peak (S3 higher) or a trough (S3 lower)
matlabbatch{3}.spm.stats.con.consess{2}.fcon.name = 'quadratic change';
matlabbatch{3}.spm.stats.con.consess{2}.fcon.weights = [-1 2 -1]; % Quadratic contrast
matlabbatch{3}.spm.stats.con.consess{2}.fcon.sessrep = 'none';

matlabbatch{3}.spm.stats.con.delete = 0;

%% Save ANOVA Batch 
filename = fullfile(results_dir, 'anova_decoding.mat');
save(filename, 'matlabbatch');

%% Run Batch 
spm_jobman('run', filename);

end
