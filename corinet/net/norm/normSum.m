function V = normSum(W,toVal)
    
%NORMSUM Scale a matrix such that the sum for each row equals toVal

V = bsxfun(@rdivide,W,sum(W,2)/toVal);

end

