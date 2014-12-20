function S = disj1(S,nodeValues)

%DISJ1 Disjunctive integration rule, for use in BlockNodePool networks
% S: struct containing following fields
%   Xi: indeces of inputs into nodeValues vector
%   Y: activation values of disjunctive nodes
%   WP: W^*W~
% nodeValues: vector containing values of all inputs and nodes in the network

%get the input
X = nodeValues(S.Xi); X(X>1) = 1;

if ~isempty(S.plot.activation)
    S.plot.activation('DISJ1',S,nodeValues);
end

%calculate node activation values
[S.Y,S.Mi] = max(bsxfun(@times,S.WP,X'),[],2);
%S.Y = S.W*X;

if ~isempty(S.plot.activation)
    S.plot.activation('DISJ2',S,nodeValues,X);
end

end

