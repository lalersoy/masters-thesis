% Description:
% This script identifies subjects with complete session data (S1, S3, S7),
% and runs an **ANOVA analysis** to test for:
%   - **Linear Change** (increase/decrease over time)
%   - **Quadratic Change** (peak at S3 or trough at S3)
%
% Dependencies:
% - SPM12
% - anova.m function
%
% Author: Deniz Lal Ersoy
% Email: ersoydenizlal@gmail.com
% Date: 2024-05-12

%% ---- Set up Paths ----

% Define base data directory
data_dir = '/path/to/derivatives/fmri_data/';
cd(data_dir);

% Add SPM and ANOVA script directories
addpath(genpath('/path/to/spm12/'));
addpath('/path/to/code/glm/anova/');

%% ---- Extract Subject IDs ----

% Extract subject IDs from directory structure
sub_list = dir(fullfile(data_dir, 'sub-*'));  
subjects = {sub_list.name};
subj_id = extractAfter(subjects, 'sub-');

% Initialize experimental group (subjects with all 3 sessions)
experimental_group = {};

for i = 1:numel(subj_id)
    subject = subj_id{i}; % Get the subject ID
    
    % Check if required session directories exist
    ses_01_dir = fullfile(data_dir, ['sub-', subject], 'ses-01/');
    ses_03_dir = fullfile(data_dir, ['sub-', subject], 'ses-03/');
    ses_07_dir = fullfile(data_dir, ['sub-', subject], 'ses-07/');
    
    if exist(ses_01_dir, 'dir') && exist(ses_03_dir, 'dir') && exist(ses_07_dir, 'dir')
        % If all required session directories exist, add subject to analysis
        experimental_group{end+1} = subject;
    end
end

%% ---- Run ANOVA ----

% Display subjects included in ANOVA
disp('Subjects with all required sessions (S1, S3, S7):');
disp(numel(experimental_group));

% Run the ANOVA function on identified subjects
anova(experimental_group);
