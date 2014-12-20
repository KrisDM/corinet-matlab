function rsult = gaussian2D(S,in)

%GAUSSIAN2D Gaussian population signal generated for 2D input
% S: struct containing following fields
%   centerX: x-center of Gaussian profiles
%   sigmaX: x-sigma of Gaussian profiles
%   centerY: y-center of Gaussian profiles
%   sigmaY: y-sigma of Gaussian profiles
%   centerX or sigmaX and centerY or sigmaY may be scalar and is expanded
% in: 2 element vector with (x,y) input values

if ~isnan(in(1))
    rx = exp(-(bsxfun(@rdivide,(S.centerX - in(1)).^2,2*S.sigmaX.^2)));
else
    rx = zeros(size(S.centerX));
end
if ~isnan(in(2))
    ry = exp(-(bsxfun(@rdivide,(S.centerY - in(2)).^2,2*S.sigmaY.^2)));
else
    ry = zeros(size(S.centerY));
end

rsult = ry(:)*rx(:)';

end

