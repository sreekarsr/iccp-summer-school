function [meanLineStd, varargout] = computeVar(frames, batchSize)

if ((nargin < 2) || isempty(batchSize))
    if size(frames,3)>500
	    batchSize = 500;
    else
        batchSize = size(frames,3);
    end
end

meanLine = zeros(1, size(frames, 3));
meanLineSq = zeros(1, size(frames, 3));
numIters = floor(size(frames, 3) / batchSize);

for iter = 1:numIters
meanLine((iter-1) * batchSize + (1:batchSize)) =...
	mean(mean(double(frames(:, :, (iter - 1) * batchSize + (1:batchSize))), 1), 2);
meanLineSq((iter-1) * batchSize + (1:batchSize)) =...
	mean(mean(double(frames(:, :, (iter - 1) * batchSize + (1:batchSize))) .^ 2, 1), 2);
end

meanLineVar = meanLineSq(:) - meanLine(:) .^ 2;
meanLineStd = squeeze(meanLineVar .^ 0.5);

if nargout>1
varargout{1} = meanLine;
end

end