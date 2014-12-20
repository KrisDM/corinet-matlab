function rsult = uniform(S,numVals)

%UNIFORM Values sampled from uniform distributions
% S: struct containing following fields
%   interval: cell array, each cell containing an interval to be sampled from
% numVals: cell array, each cell containing the number of values that need
%          to be generated in the result
% rsult: cell array, each cell containing an array where the number of rows
%        equals the value in the corresponding cell of numVals, and the number
%        of columns is given by the number of intervals to be sampled from

numRanges = numel(S.interval);
ranges = zeros(1,numRanges);
minima = zeros(1,numRanges);
for r=1:numRanges,
    ranges(r) = range(S.interval{r});
    minima(r) = min(S.interval{r});
end
numRsultCells = numel(numVals);
temp = cell(size(numVals));
for i=1:numRsultCells,
    temp{i} = bsxfun(@plus,bsxfun(@times,rand(numVals{i},numRanges),ranges),minima);
end

rsult = {temp};

end