function S = dimLearn1(S,nodeValues,dummy1) %#ok<INUSD>

%DIMLEARN1 DIM learning rule, for use in BlockNodePool networks
% Only the W weights are learned, V weights are a max-normalised copy of W
% S: struct containing following fields
%   E: activation values of error nodes
%   Y: activation values of prediction nodes
%   W: feedforward weights from error to prediction nodes
%   V: feedback weights from prediction to error nodes
%   beta: learning rate

if ~isempty(S.plot.learn)
    S.plot.learn('DIM1',S,nodeValues);
end

S.W = S.W.*(1 + (S.beta*S.Y)*(S.E'-1));
S.W(S.W<0) = 0;
S.V = bsxfun(@rdivide,S.W,max(S.W,[],2))';

if ~isempty(S.plot.learn)
    S.plot.learn('DIM2',S,nodeValues);
end
        
end

