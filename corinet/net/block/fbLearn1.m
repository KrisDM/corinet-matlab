function S = fbLearn1(S,nodeValues,wName)

%FBLEARN1 Learning rule for inter-area feedback weights in the PCBC model. 
% For use in BlockNodePool networks
% S: struct containing following fields
%   Y: activation values of prediction nodes
%   beta: learning rate
%   feedback: struct array with weightsName/inportName pairs
%   (wName): weights being adjusted with this rule
%   (iName)i: index of input into nodeValues
% nodeValues: vector containing values of all inputs and nodes in the network
% wName: name of the weights being learned

if ~isempty(S.plot.learn)
    S.plot.learn('FB1',S,nodeValues);
end

iName = S.feedback(ismember({S.feedback.weightsName},wName)).inportName;

FBIN = nodeValues(S.([iName 'i'])); FBIN(FBIN>1) = 1;
pseudoE = S.Y./((S.(wName))*FBIN);
S.(wName) = S.(wName).*(1 + (pseudoE-1)*(S.beta*FBIN)');
S.(wName)(S.(wName)<0) = 0;

if ~isempty(S.plot.learn)
    S.plot.learn('FB2',S,nodeValues);
end
        
end

