function [varargout] =  previewinteractive(vid,EnableCrossHairs)
arguments
    vid
    EnableCrossHairs = false;
end


% Choose to see a smaller field of view
vidsize = vid.VideoResolution;
center = round(vidsize / 2);

figure;
hAx = gca;
imObj = imshow(getsnapshot(vid),'Parent',hAx); % use a sample image to fix the dimensions of the image window
imObj.Parent.Visible = 'on';
if EnableCrossHairs
    drawcrosshair('Parent',hAx,'Position',(center),'LineWidth',0.5,'Color','y','StripeColor','r');
end

% Feed the live camera feed into the figure
preview(vid,imObj); %Close to stop

if nargout>0
    varargout{1} = imObj;
end
% input('Press [ENTER] when complete');
% closepreview;
end
