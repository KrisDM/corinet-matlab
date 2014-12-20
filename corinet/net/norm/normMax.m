function V = normMax(W,toVal)
    
%NORMMAX Scale a matrix such that the maximum value for each row equals toVal

V = bsxfun(@rdivide,W,max(W,[],2)/toVal);

end

