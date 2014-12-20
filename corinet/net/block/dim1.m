function S = dim1(S,nodeValues)

%DIM1 DIM integration rule, for use in BlockNodePool networks
% S: struct containing following fields
%   Xi: indeces of inputs into nodeValues vector
%   Yi: indeces of outputs into nodeValues vector
%   E: activation values of error nodes
%   Y: activation values of prediction nodes
%   W: feedforward weights from error to prediction nodes
%   V: feedback weights from prediction to error nodes
%   epsilon1: integration parameter
%   epsilon2: integration parameter
% nodeValues: vector containing values of all inputs and nodes in the
% network

%get the input
X = nodeValues(S.Xi); X(X>1) = 1;

if ~isempty(S.plot.activation)
    S.plot.activation('DIM1',S,nodeValues);
end

%calculate node activation values
S.E = X./(S.epsilon2 + S.V*S.Y);
S.Y = (S.epsilon1 + S.Y).*(S.W*S.E);

if ~isempty(S.plot.activation)
    S.plot.activation('DIM2',S,nodeValues,X);
end

end

