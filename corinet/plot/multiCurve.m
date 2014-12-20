function [lineHandles,textHandles] = multiCurve(range,values,labels)

%MULTICURVE Plot multiple curves in same plot, adding curve labels

numCurves = size(values,1);

if numCurves
    lineHandles = plot(range,values');
    hold on;
    if nargin == 3
        [maxValues,maxIndex] = max(values,[],2);
        locX = range(maxIndex);
        locY = maxValues;
        textHandles = addLabels(labels,[locX(:),locY(:)],'center','bottom');
    end
end

end


