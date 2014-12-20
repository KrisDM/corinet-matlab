function rsult = constantCell(S,numVals)

%CONSTANTCELL Create a cell array with each
%cell containing the same value.
% S: struct containing following fields
%   value: the value of each cell
% numVals: number of values in cell array
% rsult: cell array, each cell containing the same value

rsult = {num2cell(S.value*(ones(numVals,1)))};

end