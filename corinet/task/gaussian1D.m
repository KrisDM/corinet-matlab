function rsult = gaussian1D(S,in)

%GAUSSIAN1D Gaussian population signal generated for 1D input
% S: struct containing following fields
%   center: values of center of Gaussian profiles
%   sigma: values of sigma of Gaussian profiles
%   one of center or sigma may be scalar, and is expanded
% in: scalar input value

if ~isnan(in)
    rsult = exp(-(bsxfun(@rdivide,(S.center - in).^2,2*S.sigma.^2)));
else
    rsult = zeros(size(S.center));
end

end

