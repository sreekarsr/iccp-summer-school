
addpath utils;

%% connect to camera
[vid,src] = flirOpen(1);
% [vid,src] = alviumOpen(1);
% [vid,src] = baslerOpen(1);

src.ExposureTime = 2e4;

%% open camera preview
[imObj] = previewinteractive(vid,false); 

%% Connect to translation stage Z825B
% hwSerialNo = 27259994;
hwSerialNo = 27600174;
% hwSerialNo  = 27259173;
% motor = AptMotorTranslation(hwSerialNo);
motor = AptZ825B(hwSerialNo);
%% Home and set basic params 
motor.home();
% motor.setvelparams(1,1);

%% set motor initial position to about 5mm
motor.goto(5)

%% align pathlength

%% you may choose to restrict the FOV
[~,cropbox] = imcrop;
vid.ROIPosition = round(cropbox);

%% Motorized Fine adjustment (optional)
align_pathlength(motor,vid,'match_pathlength\',10e-3, 3000e-3);% with 10nm filter
motorcenter = motor.getpos;

%% Measure TCL
align_pathlength(motor,vid,'tcl_meas\',3e-3, 200e-3);% with 10nm filter
motorcenter = motor.getpos;

%% Restore full fov (if using restricted region)
vid.ROIPosition = [1 1 vid.VideoResolution-1];
    

%% Scan a coin
% insert ND filter and scene and align pathlength again by using a crop of
% the fov
[~,cropbox] = imcrop;
vid.ROIPosition = round(cropbox);

axis auto;
%% Re-align pathlength with object
align_pathlength(motor,vid,'match_pathlength\',20e-3, 2000e-3);% with 10nm filter
motorcenter = motor.getpos;

%% Restore full fov (if using restricted region)
vid.ROIPosition = [1 1 vid.VideoResolution-1];
    
%% Acquire stack

tstart = motor.getpos;
thickness = 1; %mm
tstep = 0.005; %mm

samplename = 'coin';

tpositions = (tstart - thickness/2):tstep:(tstart+thickness/2);
frames = captureSweep(motor, vid, tpositions, src.ExposureTime*1e-6 + 0.5);

motor.goto(tstart);

exposureTime = src.ExposureTime;
datestr = getdatestr();
disp('saving data...')
save(strjoin(['oct-',samplename,'-',datestr,'.mat'],''),'frames', 'tpositions','tstep','thickness','exposureTime','-v7.3');
disp('saved!')

%% Compute depthmap from stack
[~, mdIm, ~] = computeMeanDiff(frames(:,:,1:2:end),5, 'local', 20);

[maxamp, depth] = max(mdIm,[],3);

figure;imagesc(depth);title('depthmap')
colorbar;

%% adjust colorbar
% caxes([10 200]);




