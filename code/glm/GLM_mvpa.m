% GLM Function for fMRI Analysis
%
% Author: Deniz Lal Ersoy
% Email: ersoydenizlal@gmail.com
% Date: 2024-04-30
%
% Description:
% This script sets up and runs a General Linear Model (GLM) for fMRI analysis
% using SPM. It processes event timing, motion regressors, and conditions
% for statistical modeling.
%
% Dependencies:
% - SPM12
%
% Usage:
% Call the function with subject and session identifiers, grouped event onsets,
% and motion regressors.

function GLM_mvpa(subj_id, ses_id, chopstick_groups, hand_groups, onsetrest, durationrest, fd)

    % Display Subject ID 
    disp(subj_id)

    % Extracting event groups
    chopstick_1=chopstick_groups{1};
    chopstick_2=chopstick_groups{2};
    chopstick_3=chopstick_groups{3};
    chopstick_4=chopstick_groups{4};
    chopstick_5=chopstick_groups{5};
    chopstick_6=chopstick_groups{6};


    hand_1=hand_groups{1};
    hand_2=hand_groups{2};
    hand_3=hand_groups{3};
    hand_4=hand_groups{4};
    hand_5=hand_groups{5};
    hand_6=hand_groups{6};


    % Define Directories
    base_data_dir = '/path/to/derivatives/fmri_data/';
    spm_dir = '/path/to/spm12/';
    addpath(spm_dir);

    % Subject and session directories
    subj_dir = fullfile(base_data_dir, ['sub-', subj_id, '/']);
    ses_dir = fullfile(subj_dir, ses_id, '/');

    % Create GLM results directory
    glm_dir = fullfile(ses_dir, 'glm_roi_residuals/');
    if ~exist(glm_dir, 'dir')
        mkdir(glm_dir);
    end
    
    % Define fMRI model specification

    matlabbatch{1}.spm.stats.fmri_spec.dir = {glm_dir};
    matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 36;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 36;

    % Select preprocessed functional images, unsmoothed

    func_dir = strcat(ses_dir, 'func/');
    filt = '^wrasub-.*chopstick.*\.nii$'; % filename filter
    %^: Anchors the regex at the start of the string.
    %sub-: Matches the literal characters "sub-".
    %.*: Matches any sequence (or none) of characters.
    %\.nii$: Matches the literal characters ".nii" at the end of the string.
    f = cellstr(spm_select('ExtFPList', func_dir, filt, Inf));

    % Define event conditions
    %%
    matlabbatch{1}.spm.stats.fmri_spec.sess.scans = f;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).name = 'chopstick';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).onset = str2double(chopstick_1(:,1));
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).duration = str2double(chopstick_1(:,2));
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).orth = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).name = 'chopstick';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).onset = str2double(chopstick_2(:,1));
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).duration = str2double(chopstick_2(:,2));
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).orth = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).name = 'chopstick';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).onset = str2double(chopstick_3(:,1));
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).duration = str2double(chopstick_3(:,2));
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).orth = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).name = 'chopstick';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).onset = str2double(chopstick_4(:,1));
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).duration = str2double(chopstick_4(:,2));
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).orth = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).name = 'chopstick';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).onset = str2double(chopstick_5(:,1));
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).duration = str2double(chopstick_5(:,2));
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).orth = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).name = 'chopstick';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).onset = str2double(chopstick_6(:,1));
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).duration = str2double(chopstick_6(:,2));
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).orth = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).name = 'hand';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).onset = str2double(hand_1(:,1));
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).duration = str2double(hand_1(:,2));
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).orth = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(8).name = 'hand';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(8).onset = str2double(hand_2(:,1));
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(8).duration = str2double(hand_2(:,2));
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(8).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(8).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(8).orth = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(9).name = 'hand';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(9).onset = str2double(hand_3(:,1));
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(9).duration = str2double(hand_3(:,2));
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(9).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(9).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(9).orth = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(10).name = 'hand';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(10).onset = str2double(hand_4(:,1));
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(10).duration = str2double(hand_4(:,2));
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(10).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(10).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(10).orth = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(11).name = 'hand';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(11).onset = str2double(hand_5(:,1));
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(11).duration = str2double(hand_5(:,2));
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(11).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(11).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(11).orth = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(12).name = 'hand';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(12).onset = str2double(hand_6(:,1));
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(12).duration = str2double(hand_6(:,2));
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(12).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(12).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(12).orth = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(13).name = 'restchopstick';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(13).onset = onsetrest(1);
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(13).duration = durationrest(1);
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(13).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(13).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(13).orth = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(14).name = 'restchopstick';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(14).onset =  onsetrest(2);
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(14).duration = durationrest(2);
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(14).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(14).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(14).orth = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(15).name = 'restchopstick';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(15).onset =  onsetrest(3);
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(15).duration = durationrest(3);
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(15).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(15).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(15).orth = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(16).name = 'restchopstick';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(16).onset =  onsetrest(4);
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(16).duration = durationrest(4);
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(16).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(16).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(16).orth = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(17).name = 'restchopstick';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(17).onset =  onsetrest(5);
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(17).duration = durationrest(5);
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(17).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(17).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(17).orth = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(18).name = 'restchopstick';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(18).onset =  onsetrest(6);
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(18).duration = durationrest(6);
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(18).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(18).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(18).orth = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(19).name = 'resthand';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(19).onset =  onsetrest(7);
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(19).duration = durationrest(7);
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(19).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(19).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(19).orth = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(20).name = 'resthand';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(20).onset =  onsetrest(8);
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(20).duration = durationrest(8);
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(20).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(20).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(20).orth = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(21).name = 'resthand';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(21).onset =  onsetrest(9);
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(21).duration = durationrest(9);
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(21).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(21).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(21).orth = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(22).name = 'resthand';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(22).onset =  onsetrest(10);
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(22).duration = durationrest(10);
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(22).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(22).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(22).orth = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(23).name = 'resthand';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(23).onset =  onsetrest(11);
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(23).duration = durationrest(11);
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(23).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(23).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(23).orth = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(24).name = 'resthand';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(24).onset =  onsetrest(12);
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(24).duration = durationrest(12);
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(24).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(24).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(24).orth = 1;

    % Add framewise displacement regressor

    matlabbatch{1}.spm.stats.fmri_spec.sess.multi = {''};
    matlabbatch{1}.spm.stats.fmri_spec.sess.regress.name = 'fd';
    matlabbatch{1}.spm.stats.fmri_spec.sess.regress.val = fd;
    matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg =  cellstr(strcat(func_dir,'rp_asub-',subj_id,'_',ses_id,'_task-chopstick_bold.txt'));
    matlabbatch{1}.spm.stats.fmri_spec.sess.hpf = 128;
    matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
    matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
    matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
    matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
    matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
    matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
    matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';
    
    
    % GLM Model Estimation 

    matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch{2}.spm.stats.fmri_est.write_residuals = 1;
    matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
    matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    
    % Contrast Specification 
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'chopstick vs hand';
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [1 1 1 1 1 1 -1 -1 -1 -1 -1 -1];
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'hand vs chopstick';
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [-1 -1 -1 -1 -1 -1 1 1 1 1 1 1];
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.name = 'chopstick vs rest';
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.weights = [1 1 1 1 1 1 0 0 0 0 0 0 -1 -1 -1 -1 -1 -1 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{4}.tcon.name = 'hand vs rest';
    matlabbatch{3}.spm.stats.con.consess{4}.tcon.weights = [0 0 0 0 0 0 1 1 1 1 1 1 0 0 0 0 0 0 -1 -1 -1 -1 -1 -1];
    matlabbatch{3}.spm.stats.con.consess{4}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.delete = 0;


    %% Save GLM batch 
    filename = strcat(glm_dir,'sub-',subj_id,'_',ses_id,'_glm_roi_residuals.mat');
    save(filename, 'matlabbatch');

    % % run batch 
    % spm_jobman('run', filename);

end

