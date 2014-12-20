function S = pcbcbLearn1(S,nodeValues,dummy1) %#ok<INUSD>

%PCBCBLEARN1 Learning rule for inter-area feedback weights in the PCBC model. 
% For use in BlockNodePool networks
% S: struct containing following fields
%   E: activation values of error nodes
%   Y: activation values of prediction nodes
%   W: feedforward weights from error to prediction nodes
%   V: feedback weights from prediction to error nodes
%   beta: learning rate
%   feedback: struct array with weightsName/inportName pairs
%   (wName): weights being adjusted with this rule
%   (iName)i: index of input into nodeValues
% nodeValues: vector containing values of all inputs and nodes in the
% network

if ~isempty(S.plot.learn)
    S.plot.learn('PCBC1',S,nodeValues);
end

YE = (S.beta*S.Y)*(S.E'-1);
S.W = S.W.*(1 + YE);
S.W(S.W<0) = 0;
S.V = S.V.*(1 + bsxfun(@plus,YE',S.beta*(S.Y'>1)));
S.V(S.V<0) = 0;

for fb=S.feedback
    wName = fb.weightsName;
    FBIN = nodeValues(S.([fb.inportName 'i'])); FBIN(FBIN>1) = 1;
    pseudoE = S.Y./((S.(wName))*FBIN);
    S.(wName) = S.(wName).*(1 + (pseudoE-1)*(S.beta*FBIN)');
    S.(wName)(S.(wName)<0) = 0;    
end

if ~isempty(S.plot.learn)
    S.plot.learn('PCBC2',S,nodeValues);
end

