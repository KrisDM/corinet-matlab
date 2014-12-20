function out = randGen(name,numVals,varargin)

%RANDGEN Generate random numbers for particular distributions

switch name
    case 'GEOMETRIC'
        assert(numel(varargin) > 0);
        p = [varargin{:}];
        numP = numel(p);
        out = ceil(abs(log(rand(numVals,numP))./repmat(log(1-p),numVals,1)));
    case 'UNIFORM',
        assert(numel(varargin) > 0);
        ranges = [varargin{:}];
        if size(ranges,1) == 1
            numRanges = numel(ranges)/2;
            ranges = reshape(ranges,2,numRanges);
        else
            numRanges = size(ranges,2);
        end
        out = repmat(min(ranges),numVals,1) + ...
                repmat(abs(ranges(2,:)-ranges(1,:)),numVals,1).*rand(numVals,numRanges);
    otherwise,
        ME = MException('randGen:name',...
                    'Unknown distribution name');
        throw(ME);
end

end

