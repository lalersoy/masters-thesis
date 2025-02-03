% Cross-Validation using The Decoding Toolbox (TDT)
%
% Author: Deniz Lal Ersoy
% Email: ersoydenizlal@gmail.com
% Date: 2024-05-12
%
% Description:
% This function performs a searchlight-based decoding analysis using The Decoding Toolbox (TDT).
% It extracts beta images from a specified GLM directory and runs an SVM classifier.
%
% Dependencies:
% - SPM12 (Statistical Parametric Mapping)
% - The Decoding Toolbox (TDT) - https://sites.google.com/site/tdtdecodingtoolbox/
%
% Reference:
% Hebart, M. N., Görgen, K., & Haynes, J. D. (2015). 
% The Decoding Toolbox (TDT): A versatile software package for multivariate analyses of functional imaging data. 
% Frontiers in Neuroinformatics, 8, 88. https://doi.org/10.3389/fninf.2014.00088
%
% Usage:
% crossvalidation('XXXXX', 'ses-XX')

function crossvalidation(subj_id, ses_id)

    % Define paths
    base_dir = '/path/to/derivatives/fmri_data/'; 
    spm_dir = '/path/to/matlab/spm12/'; % Path to SPM12
    decoding_dir = '/path/to/matlab/decoding_toolbox/'; % Path to TDT

    % Add required toolboxes
    addpath(spm_dir);
    addpath(decoding_dir);

    % Define subject and session directories
    subj_dir = fullfile(base_dir, ['sub-', subj_id]);
    ses_dir = fullfile(subj_dir, ses_id);

    % Define GLM beta image directory
    beta_loc = fullfile(ses_dir, 'glm_roi');

    % Set decoding defaults (default classifier: L2-norm SVM)
    cfg = decoding_defaults;

    % Select analysis method and searchlight radius (in mm)
    cfg.analysis = 'searchlight';
    cfg.searchlight.radius = 5;

    % Create results directory
    searchlight_dir = fullfile(beta_loc, 'tdt_searchlight');
    mkdir(searchlight_dir, 'hand_rest');
    cfg.results.dir = fullfile(searchlight_dir, 'hand_rest');

    % Define mask for analysis
    cfg.files.mask = fullfile(beta_loc, 'mask.nii');
    cfg.results.overwrite = 1;

    % Define conditions (adjust for chopstick-rest comparison if needed)
    labelname1 = 'hand';
    labelname2 = 'resthand';

    % Extract regressor names from SPM.mat
    regressor_names = design_from_spm(beta_loc);

    % Assign label values
    labelvalue1 = 1;
    labelvalue2 = -1;

    % Configure output options
    cfg.results.output = {'accuracy_minus_chance', 'confusion_matrix'};
    cfg.plot_design = 1;

    % Describe data
    cfg = decoding_describe_data(cfg, {labelname1, labelname2}, [labelvalue1, labelvalue2], regressor_names, beta_loc);

    % Manually specify cross-validation chunks
    cfg.files.chunk = [1; 2; 3; 4; 5; 6; 1; 2; 3; 4; 5; 6];
    cfg.design = make_design_cv(cfg);

    display_design(cfg);

    % Run decoding analysis
    [results, cfg] = decoding(cfg);

end
