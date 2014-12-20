function S = pcbcaLearn1(S,dummy1,dummy2) %#ok<INUSD>

%PCBCALEARN1 PCBC learning rule, for use in BlockNodePool networks
% Only the W weights are learned, V and U weights are a max-normalised copy of W
% S: struct containing following fields
%   E: activation values of error nodes
%   Y: activation values of prediction nodes
%   W: feedforward weights from error to prediction nodes
%   V: feedback weights from prediction to error nodes
%   U: feedback weights from this area to previous areas
%   beta: learning rate

S.W = S.W.*(1 + (S.beta*S.Y)*(S.E'-1));
S.W(S.W<0) = 0;
S.V = bsxfun(@rdivide,S.W,max(S.W,[],2))';
S.U = S.V;
        
end

