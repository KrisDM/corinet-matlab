function S = disjLearn1(S,nodeValues,dummy1) %#ok<INUSD>

%DISJLEARN1 DISJ learning rule, for use in BlockNodePool networks
% S: struct containing following fields
%   Xi: indeces into nodeValues
%   Y: activation values of prediction nodes
%   W: feedforward weights from error to prediction nodes
%   gamma: learning rate

X = nodeValues(S.Xi); X(X>1) = 1;

if ~isempty(S.plot.learn)
    S.plot.learn('DISJ1',S,nodeValues,X);
end

S.W = S.W.*(1 + (S.gamma*S.Y)*X'); 
S.W = normSum(S.W',S.psi)';
S.WP = normMax(S.W,1).*(normMax(S.W',1))';

if ~isempty(S.plot.learn)
    S.plot.learn('DISJ2',S,nodeValues,X);
end

end

