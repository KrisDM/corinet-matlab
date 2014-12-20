function W = initNormal(numNodes,numInputs,m,s)

%INITNORMAL Initialise weight matrix with weights drawn from a normal
%distribution with given mean and standard deviation

W = m + s*randn(numNodes,numInputs);
W(W<0)=0;

end

