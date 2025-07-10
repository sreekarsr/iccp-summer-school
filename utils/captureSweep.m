function [frames, varargout] = captureSweep(motor, vidcam, transl_positions, pausetime, type)
%CAPTURESWEEP Capture a series of images by translating the stage
%   A common operation that's used in several places
arguments
    motor
    vidcam % videoinput or ThorPolCam object
    transl_positions
    pausetime = 0.5; % time to wait after moving motor before capturing    
    type = 'uint16'
end


ROI = vidcam.ROIPosition; % works for both thorpolcam and videoinput object
vidsize = ROI(3:4);

frames = zeros([vidsize(2) vidsize(1) length(transl_positions)],type);

if(nargout > 1)
    getRaw = true;
    framesRaw = zeros([vidsize(2) vidsize(1) length(transl_positions)],'uint16');
else
    getRaw = false;
end

for i=1:numel(transl_positions)
    motor.goto(transl_positions(i)); 
    pause(pausetime);
%     sumimg(:)= 0;
%     for k=1:numimgavg
%         sumimg = sumimg + getsnapshot(vid);
%     end
%     frames(:,:,i) = sumimg / numimgavg;
    disp(['Position ' num2str(i) ' / ' num2str(numel(transl_positions))]);

    if(~getRaw)
        frames(:, :, i) =  getsnapshot(vidcam); % should work for both thorpolcam and videoinput objects (overloaded with arguments)e
    else
        [frames(:, :, i), framesRaw(:,:,i)] =  getsnapshot(vidcam); % should work for both thorpolcam and videoinput objects (overloaded with arguments)e
    end

end

if(nargout > 1)
    varargout{1} = framesRaw;
else
    varargout = {};
end

end

