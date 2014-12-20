function S = pcbcb2(S,nodeValues)

%PCBCB2 PCBCB integration rule, for use in BlockNodePool networks
%This rule is meant when all feedback weights are being learned
% S: struct containing following fields
%   Xi: indices of feedforward inputs into nodeValues vector
%   Yi: indices of outputs into nodeValues vector
%   E: activation values of error nodes
%   Y: activation values of prediction nodes
%   W: feedforward weights from error to prediction nodes
%   V: feedback weights from prediction to error nodes
%   epsilon1: integration parameter
%   epsilon2: integration parameter
%   theta: feedback saturation parameter
%   feedback: struct array, containing "weightsName/inportName/etaName" triplets
%   Any additional feedback weights/inport indices/eta parameters
% nodeValues: vector containing values of all inputs and nodes in the
% network

%get the input
FB = ones(size(S.Y));
for fbs=S.feedback
    FBIN = nodeValues(S.([fbs.inportName 'i'])); FBIN(FBIN>1) = 1;
    FB = FB + S.(fbs.etaName)*(S.(fbs.weightsName))*FBIN;
end
FB(FB>S.theta) = S.theta;
X = nodeValues(S.Xi); X(X>1) = 1;

if ~isempty(S.plot.activation)
    S.plot.activation('PCBC1',S,nodeValues,FB);
end

%calculate node activation values
S.Y = (S.epsilon1 + S.Y).*(S.W*S.E).*FB;
S.E = X./(S.epsilon2 + S.V*S.Y);

if ~isempty(S.plot.activation)
    S.plot.activation('PCBC2',S,nodeValues,X,FB);
end

end

