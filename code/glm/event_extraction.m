% Event Extraction for fMRI Analysis
%
% Author: Deniz Lal Ersoy
% Email: ersoydenizlal@gmail.com
% Date: 2024-04-29
%
% Description:
% This script processes fMRI event-related data for GLM analysis.
% It reads subject and session data, loads event timing from TSV files,
% extracts motion regressors, computes framewise displacement, and 
% calls a GLM function for analysis.
%
% Dependencies:
% - SPM12
% - tsvread function
% - GLM_mvpa function
%
% Usage:
% Run the script after setting up SPM12 and necessary dependencies.

% Specify data directories
data_dir = '/path/to/derivatives/fmri_data/';
addpath(genpath('/path/to/spm12/'));

tsv_dir = '/path/to/derivatives/code/glm/';
addpath(tsv_dir);

% Extract subject IDs from the directory
sub_list = dir(fullfile(data_dir, 'sub*'));
subjects = {sub_list.name};
ids = extractAfter(subjects, 'sub-');

% Loop through each subject and session
for i = 1:length(ids)
    subj_dir = fullfile(data_dir, ['sub-', ids{i}, '/']);
    subj_id = ids{i};
    ses_list = dir(fullfile(subj_dir, 'ses*'));
    sessions = {ses_list.name};
    
    for ses = 1:length(sessions)
        func_folder = fullfile(subj_dir, sessions{ses}, 'func/');
        ses_id = sessions{ses};
        
        % Load motion parameters for multiple regressors
        rptxt = load([func_folder, 'rp_asub-', subj_id, '_', sessions{ses}, '_task-bold.txt']);
        
        % Load event timing from TSV file
        tsv_file = fullfile(func_folder, ['sub-', subj_id, '_', sessions{ses}, '_task-events.tsv']);
        [data, hdr, raw] = tsvread(tsv_file);
        raw = raw(2:end, :);
        
        % Extract event details
        onsets = raw(:, 1);
        durations = raw(:, 2);
        trial_type = raw(:, 3);
        
        chopstick_groups = {};
        hand_groups = {};
        current_group = [];
        current_trial_type = '';
        
        % Group events by trial type
        for i = 1:length(trial_type)
            if strcmp(trial_type{i}, 'chopstick') && strcmp(trial_type{i}, current_trial_type)
                current_group = [current_group; onsets(i), durations(i), trial_type{i}];
            elseif strcmp(trial_type{i}, 'hand') && strcmp(trial_type{i}, current_trial_type)
                current_group = [current_group; onsets(i), durations(i), trial_type{i}];
            else
                if strcmp(current_trial_type, 'chopstick')
                    chopstick_groups{end+1} = current_group;
                elseif strcmp(current_trial_type, 'hand')
                    hand_groups{end+1} = current_group;
                end
                current_group = [onsets(i), durations(i), trial_type{i}];
                current_trial_type = trial_type{i};
            end
        end
        
        % Identify null trials (rest conditions)
        rest_index = 1;
        onsetrest = zeros(12, 1);
        durationrest = zeros(12, 1);
        
        for t = 1:size(raw, 1)
            onset = str2double(raw{t, 1});
            duration = str2double(raw{t, 2});
            trial = raw{t, 3};
            
            if strcmp(trial, 'null')
                onsetrest(rest_index) = onset;
                durationrest(rest_index) = duration;
                rest_index = rest_index + 1;
            end
        end
        
        % Compute framewise displacement (FD) for motion regressors
        rp_diff_trans = diff(rptxt(:, 1:3));  % Translation differences
        rp_diff_rotat = diff(rptxt(:, 4:6) * 50);  % Convert radians to degrees
        
        fd = zeros(length(rp_diff_trans), 1);
        
        for k = 1:length(fd)
            fd(k) = sum(abs(rp_diff_trans(k, :))) + sum(abs(rp_diff_rotat(k, :)));
        end
        
        fd = vertcat(0, fd);
        
        % Call the GLM function for analysis
        GLM_mvpa(subj_id, ses_id, chopstick_groups, hand_groups, onsetrest, durationrest, fd);
    end
end
