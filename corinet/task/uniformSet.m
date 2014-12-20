function rsult = uniformSet(S,numVals)

%UNIFORMSET Values sampled uniformely from sets
% S: struct containing following fields
%   set: cell array, each cell containing the set to be sampled from
% numVals: cell array, each cell containing the number of values that need
%          to be generated in the result
% rsult: cell array, each cell containing an array where the number of rows
%        equals the value in the corresponding cell of numVals, and the number
%        of columns is given by the number of intervals to be sampled from

numRanges = numel(S.set);
setSizes = zeros(1,numRanges);
for r=1:numRanges,
    setSizes(r) = size(S.set{r},1);
end
numRsultCells = numel(numVals);
temp = cell(size(numVals));
for i=1:numRsultCells,
    setRowIndices = ceil(bsxfun(@times,rand(numVals{i},numRanges),setSizes));
    t = [];
    for j=1:numRanges
        t = horzcat(t,S.set{j}(setRowIndices(:,j),:));
    end    
    temp{i} = t;
end

rsult = {temp};

end