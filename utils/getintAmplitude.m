function [interfVector,interfImages] = getintAmplitude(frames, avgintensity, patchSize)

% Subtract to estimate interference term.
interfImages = abs(double(frames) - avgintensity);    

%mdVector = squeeze(mean(mean(mdBlurred, 1), 2));
interfVector = mean(interfImages,[1 2]);

% patch averaging to estimate sinusoid amplitude;
interfImages = convn(convn(interfImages, ones(patchSize, 1, 1), 'same'),...
			ones(1, patchSize, 1) / patchSize ^ 2, 'same');

% mdBlurred = imgaussfilt(mdBlurred, patchSize); 

end