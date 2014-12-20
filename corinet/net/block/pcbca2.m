function S = pcbca2(S,nodeValues)

%PCBCA2 PCBCA integration rule, for use in BlockNodePool networks
%This rule is meant for use with U weights that are not learned
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
%   iFeedback: struct array, containing "inportName/etaName" pairs
%   oFeedback: struct array, containing "outportName/Ui" pairs
%   Any additional feedback weights/inport indices/output values
% nodeValues: vector containing values of all inputs and nodes in the network

FB = ones(size(S.Y));
for ifb=S.iFeedback
    FB = FB + S.(ifb.etaName)*nodeValues(S.([ifb.inportName 'i']));
end
FB(FB>S.theta) = S.theta;

S.Y = (S.epsilon1 + S.Y).*(S.W*S.E).*FB;
S.E = nodeValues(S.Xi)./(S.epsilon2 + S.V*S.Y);

for ofb=S.oFeedback
    S.(ofb.outportName) = S.U(ofb.Ui,:)*S.Y;
end

end

