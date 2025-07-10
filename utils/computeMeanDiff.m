function [mdVector, mdImage, Blurred] = computeMeanDiff(frames, patchSize, avgtype, temporalWindow)

arguments
    frames % Ysize x Xsize x numframes
    patchSize = 10 % size of the square patch over which averaging is done to approximate amplitude of the sinusoid.
    avgtype = 'local'
    temporalWindow = nan % needs to be specified if local average used
end

% Compute average intensity (either local or global average).
if strcmp(avgtype,'global')
    Blurred = mean(frames,3); % per-pixel average of all frames
else
    
    if isa(frames, 'uint8')
        frames = im2single(frames);
    end

    if isa(frames, 'uint16')
        frames = im2double(frames);
    end
    
    Blurred = convn(frames, ones(1, 1, temporalWindow) / temporalWindow, 'same');

    % to exclude zeros : Alternatively - average only over one side?
    halfWindow = temporalWindow / 2;

    Blurred(:, :, 1:halfWindow) = repmat(Blurred(:, :, halfWindow + 1),...
			    [1 1 halfWindow]);
    Blurred(:, :, end-(halfWindow - 1):end) = repmat(Blurred(:, :, end - halfWindow),...
			    [1 1 halfWindow]);

end

[mdVector, mdImage] = getintAmplitude(frames,Blurred, patchSize);
