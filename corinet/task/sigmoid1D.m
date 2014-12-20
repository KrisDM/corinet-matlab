function rsult = sigmoid1D(S,in)

%SIGMOID1D Sigmoid population signal generated for 1D input value
% S: struct containing following fields
%   inflection: values of inflection points of sigmoid profiles
%   slope: values of slope factors of Sigmoid profiles
%   one of inflection or slope can be scalar, and is expanded
% in: scalar input value

if ~isnan(in)
    rsult = 1./(1+exp(bsxfun(@rdivide,(S.inflection - in),S.slope)));
else
    rsult = zeros(size(S.inflection));
end

end

