function S = disjReset1(S)

%DISJRESET1 Reset rule for DISJ, reset Y to all zeros
% S: struct containing following fields
%   Y: activation values of prediction nodes

S.Y = zeros(size(S.Y));

end

