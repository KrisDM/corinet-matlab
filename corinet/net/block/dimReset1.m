function S = dimReset1(S)

%DIMRESET1 Reset rule for DIM, reset E and Y to all zeros
% S: struct containing following fields
%   E: activation values of error nodes
%   Y: activation values of prediction nodes

S.E = zeros(size(S.E));
S.Y = zeros(size(S.Y));

end

