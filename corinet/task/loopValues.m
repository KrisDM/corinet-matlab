function rsult = loopValues(S,varargin)

%LOOPVALUES Unroll tbe loops for a set of input ranges
% S: struct with following fields:
%   outportColumns: cell array with each cell containing column numbers for rsult 
% varargin: cell arrary, one cell for each loop
% rsult: cell array of unrolled loop values, one cell for each outport of
% the encompassing task. Each cell contains a cell array where, in turn,
% each cell is a row vector with one row per loop values that belong
% together

temp = loopUnroll(varargin{:});

rsult = cell(1,numel(S.outportColumns));
for o=1:numel(S.outportColumns)
    rsult{o} = num2cell(temp(:,S.outportColumns{o}),2);
end

end