function rsult = combine(S,varargin)

%COMBINE Combine one set of values to another set of values using a combine
%function (e.g., add or subtract)
% S: struct with following fields:
%   inportCells: cell array with 2 cells containing cell indexes into varargin 
%   combine: function handle to a combine function
% varargin: cell arrary, each cell containing values from one inport
% rsult: cell array of unrolled loop values, one cell for each outport of
% the encompassing task. Each cell contains a cell array where, in turn,
% each cell is a row vector with one row per loop values that belong
% together

numRsults = numel(varargin{1});
in1 = horzcat(varargin{S.inportCells{1}});
in2 = horzcat(varargin{S.inportCells{2}});

temp = cell(numRsults,1);
for i=1:numRsults
    temp{i} = bsxfun(S.combine,horzcat(in1{i,:}),horzcat(in2{i,:}));
end

rsult = {temp};

end