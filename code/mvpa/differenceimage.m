% Compute accuracy differences in searchlight decoding results
%
% Author: Deniz Lal Ersoy
% Email: ersoydenizlal@gmail.com
%
% Description:
% This script processes fMRI decoding results from The Decoding Toolbox (TDT).
% It computes accuracy differences between conditions using SPM's `imcalc`.
%
% Dependencies:
% - SPM12
% - The Decoding Toolbox (TDT)
% - imcalc (https://www.nitrc.org/projects/imcalc/)
%
% Usage:
% Run this script in MATLAB after generating searchlight results.

% Define data directories
data_dir = '/path/to/derivatives/fmri_data/';
spm_dir = '/path/to/matlab/spm12/';

% Add SPM paths
addpath(genpath(spm_dir));
addpath(genpath(fullfile(spm_dir, 'imcalc')));

% Extract subject IDs from directory names
sub_list = dir(fullfile(data_dir, 'sub-*'));
subjects = {sub_list.name};
ids = extractAfter(subjects, 'sub-');

% Loop through subjects and sessions
for i = 1:length(ids)
    subj_dir = fullfile(data_dir, ['sub-' ids{i}]);
    subj_id = ids{i};
    ses_list = dir(fullfile(subj_dir, 'ses-*'));
    sessions = {ses_list.name};
    
    for ses = 1:length(sessions)
        ses_id = sessions{ses};
        glm_dir = fullfile(subj_dir, ses_id, 'glm_roi/tdt_searchlight/');
        chop_dir = fullfile(glm_dir, 'chop_rest/');
        hand_dir = fullfile(glm_dir, 'hand_rest/');
        
        % Define file paths
        p1 = fullfile(chop_dir, 'res_accuracy_minus_chance.nii');
        p2 = fullfile(hand_dir, 'res_accuracy_minus_chance.nii');
        
        % Change to GLM directory
        cd(glm_dir);
        
        % Compute differences using SPM's imcalc
        spm_imcalc_ui([p1; p2], 'dif_c_accuracy_minus_chance.nii', 'i1 - i2');
        spm_imcalc_ui([p1; p2], 'dif_h_accuracy_minus_chance.nii', 'i2 - i1');
        
        % Clear variables
        clear p1 p2;
    end
end

disp('Accuracy difference computation complete.');