function [loopVals,loopIndex,loopLengths] = loopUnroll(varargin)

%LOOPUNROLL Unroll a number of loops into a set of values that can be 
%processed in a single loop

assert(nargin > 0);
numLoops = nargin;

if numLoops == 1
    loopVals = varargin{1}(:);
    loopLengths = length(loopVals);
    loopIndex = (1:loopLengths)';
else
    loopLengths = zeros(size(varargin));
    tempIndex = cell(size(varargin));
    V = cell(size(varargin));
    I = cell(size(varargin));
    
    for loopCounter=1:numLoops
        loopLengths(loopCounter) = length(varargin{loopCounter});
        tempIndex{loopCounter} = (1:loopLengths(loopCounter))';
    end
    
    [V{:}] = ndgrid(varargin{:});
    [I{:}] = ndgrid(tempIndex{:});
    
    numLoopVals = prod(loopLengths);
    loopVals = zeros(numLoopVals,numLoops);
    loopIndex = zeros(numLoopVals,numLoops);
    for loopCounter=1:numLoops
        loopVals(:,loopCounter) = V{loopCounter}(:);
        loopIndex(:,loopCounter) = I{loopCounter}(:);
    end
end

end

