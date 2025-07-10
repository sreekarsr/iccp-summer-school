function [meanvec] = align_pathlength(motor, vidcam, folder, step, lim)
%% Pathlength matching
% Capture an image at each position of the piezo mirror and find the index at 
% which interference is seen for reference sources.
arguments
    motor    
    vidcam % videoinput OR ThorPolCam object
    folder = ''
    step = 0.05
    lim = 1
end


mkdir(folder)
% motor.goto(center);
center = motor.getpos;
fprintf('Center position : %g',center);
positions = (-lim:step:lim) + center;


frames = captureSweep(motor, vidcam, positions, 0.3);

% preview(vid); pause(5);
% ROI = vid.ROIPosition;
% vidsize = ROI(3:4);
% frames = zeros([vidsize(2) vidsize(1) numel(positions)], 'uint16');
% Acquire frames (one at each piezo position)
% for i=1:numel(positions)
%     motor.goto(positions(i)); 
%     pause(0.5)
% %     pause(2);
%     frames(:,:,i) = getsnapshot(vid);
%     disp(['Position ' num2str(i) ' / ' num2str(numel(positions))]);
% %     imwrite(frames(:,:,i),[folder, 'position_',sprintf('%04d',positions(i)),'.png'])
% end


%% Compute the index of interference.
[meanLineStd, meanLine] = computeVar(frames,10);
figure; plot(positions, meanLineStd);
set(gca, 'TickLabelInterpreter', 'latex'); set(gca, 'TickLabelInterpreter', 'latex');
xlabel('Translation stage position', 'Interpreter', 'latex');
ylabel('Interference contrast', 'Interpreter', 'latex');
set(gca, 'FontSize', 20); axis tight; drawnow;
saveas(gcf,[folder 'interference_contrast_var.png']);

%% Take motor to selected index
[maxval,maxidx] = max(meanLineStd);

motor.goto(positions(maxidx))

setposframe = getsnapshot(vidcam); % works for both videoinput or ThorPolCam objects

imwrite(setposframe,[folder 'setpos.png']);


%% Compute average to see sinusoidal variation
meanvec = mean(frames,[1,2]);
figure;
plot(squeeze(positions), squeeze(meanvec));
set(gca, 'TickLabelInterpreter', 'latex'); set(gca, 'TickLabelInterpreter', 'latex');
xlabel('Translation stage position', 'Interpreter', 'latex');
ylabel('Average intensity', 'Interpreter', 'latex');
set(gca, 'FontSize', 20); axis tight; drawnow;
saveas(gcf,[folder 'avg-intensity.png']);


%% Save contrast data
save([folder 'contrast.mat'], 'meanLineStd', 'positions', '-v7.3');

%%  save frames as video
% c = input('Save frames?','s');
% if strcmp(c,'y')
% fprintf('Saving frames..')
% save([folder 'frames.mat'], 'frames', 'positions', '-v7.3');
% end

fprintf('Saving frames to video...');
try
savevid(im2uint8(frames), [folder 'interf_capture.mp4'])
catch
warning('Video saving failed')
end

