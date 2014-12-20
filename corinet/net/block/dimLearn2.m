function S = dimLearn2(S,nodeValues,dummy1) %#ok<INUSD>

%DIMLEARN2 DIM learning rule, for use in BlockNodePool networks
% Both W and V are learned
% S: struct containing following fields
%   E: activation values of error nodes
%   Y: activation values of prediction nodes
%   W: feedforward weights from error to prediction nodes
%   V: feedback weights from prediction to error nodes
%   beta: learning rate

if ~isempty(S.plot.learn)
    S.plot.learn('DIM1',S,nodeValues);
end

YE = (S.beta*S.Y)*(S.E'-1);
S.W = S.W.*(1 + YE);
S.W(S.W<0) = 0;
S.V = S.V.*(1 + bsxfun(@plus,YE',S.beta*(S.Y'>1)));
S.V(S.V<0) = 0;

if ~isempty(S.plot.learn)
    S.plot.learn('DIM2',S,nodeValues);
end

end

