function rsult = geometric(S,numVals)

%GEOMETRIC Values sampled from geometric distributions
% S: struct containing following fields
%   p: parameter of the geometric distribution
% numVals: number of values to be sampled
% rsult: cell array, each cell containing a geometric random value

rsult = {num2cell(ceil(abs(bsxfun(@rdivide,log(rand(numVals,1)),log(1-S.p)))))};

end