



%% open camera
addpath utils;
[vid,src] = fliropen(2e4);


%% open camera preview
[imObj] = previewinteractive(vid,true);


%% Connect to translation stage
hwSerialNo = 27259994;
motor = AptMotorTranslation(hwSerialNo);
%%
motor.home();
motor.setvelparams(1,1);

motorcenter = 13.7118;

% motorcentre_coin = 10.9968;
%% align pathlength

% crop part of image
[~,cropbox] = imcrop;
vid.ROIPosition = round(cropbox);
%%
% align_pathlength(motor,vid,'ref_match\',40e-3, 2000e-3);
align_pathlength(motor,vid,'oct_align\',10e-3, 3000e-3);% with 1nm/10nm filter
% align_pathlength(motor,vid,'ref_match\',1e-3, 50e-3);


%% Restore full fov
vid.ROIPosition = [1 1 vid.VideoResolution-1];
    
%% Do scan with full fov

% N = 100;
% tpositions = tstart + deltat * (-N:1:N) ;
tstart = motor.getpos;
thickness = 1.5; %mm
% tstep = 0.0025;%mm
% thickness = 4;
tstep = 0.005;

tpositions = (tstart - thickness/2):tstep:(tstart+thickness/2);
frames = captureSweep(motor, vid, tpositions, src.ExposureTime*1e-6 + 0.5);

motor.goto(tstart);

exposureTime = src.ExposureTime;
save('oct-quartereagle02jul-.mat','frames', 'tpositions','tstep','thickness','exposureTime','-v7.3');






%% Compute depthmap
[~, mdIm, ~] = computeMeanDiff(frames(:,:,1:2:end),5, 'local', 20);

[maxamp, depth] = max(mdIm,[],3);

figure;imagesc(depth);title('depthmap')





