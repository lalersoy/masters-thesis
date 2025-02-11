%% Batch Processing for fMRI Preprocessing
% Author: Deniz Lal Ersoy
% Email: ersoydenizlal@gmail.com
% Date: 2023-05-25
% 
% Description:
% This script extracts subject IDs from the dataset directory and
% runs the preprocessing function (`preprocessing_chopstick`) for each subject.

% Define root directory containing subjects
data_dir = '$HOME/path/to/derivatives/fmri_data';

% Get list of subject folders
sub_list = dir(fullfile(data_dir, 'sub-*')); 
subjects = {sub_list.name}; % Extract subject folder names
ids = extractAfter(subjects, "sub-"); % Extract numeric subject IDs

% Loop through all subjects and run preprocessing
for i = 1:numel(ids)
    subj_id = char(ids(i));
    fprintf('Processing Subject: %s\n', subj_id);
    preprocessing_chopstick(subj_id);
end

fprintf('All subjects processed successfully.\n');
