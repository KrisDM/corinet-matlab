function v = createBeginAndEndIndex(listOf,startInd)

if nargin < 2
    startInd = 1;
end
numInd = length(listOf);
v = zeros(numInd,2);
tempEnd = startInd - 1;
for i=1:numInd,
    tempStart = tempEnd + 1;
    tempEnd = tempEnd + listOf(i);
    v(i,:) = [tempStart,tempEnd];
end

end

