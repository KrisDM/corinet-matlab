function S = pcbcaReset1(S)

%PCBCARESET1 Reset rule for PCBCA, reset E, Y and all YFB to 0
% S: struct containing following fields
%   E: activation values of error nodes
%   Y: activation values of prediction nodes
%   oFeedback: struct array, containing "outportName" fields

S.E = zeros(size(S.E));
S.Y = zeros(size(S.Y));

for ofb=S.oFeedback
    S.(ofb.outportName) = zeros(size(S.(ofb.outportName)));
end

end

