function [crossHandles,textHandles] = ...
    multiContour(rangeX,rangeY,values,contourLevel,cutoff,colorOrder,labels)

%MULTICONTOUR Plot multiple contours in same plot, adding contour labels

if nargin < 6
    colorOrder = 'k';
end
if nargin < 5
    cutoff = 0;
end

numColors = length(colorOrder);
numContours = size(values,1);
numDims = ndims(values);
numX = length(rangeX);
numY = length(rangeY);
crossHandles = zeros(numContours,1);
contourPlotted = false(numContours,1);
if numContours
    maxX = zeros(numContours,1);
    maxY = zeros(numContours,1);
    maxZ = zeros(numContours,1);
    for j=1:numContours,
        [maxZ(j),maxIndex] = max(values(j,:));
        [maxX(j),maxY(j)] = ind2sub([numX,numY],maxIndex);
        c = contourLevel*maxZ(j);
        currentColor = colorOrder(rem(j-1,numColors)+1);
        switch numDims
            case 2,
                plotVals = reshape(values(j,:),numX,numY);
            case 3,
                plotVals = squeeze(values(j,:,:));
        end
        if max(plotVals(:)) > cutoff
            contour(rangeX,rangeY,plotVals',[c c],'LineColor',currentColor);
            hold on;
            crossHandles(j) = plot(rangeX(maxX(j)),rangeY(maxY(j)),['+' currentColor]);
            contourPlotted(j) = true;
        end
    end
    if nargin == 7
        locX = rangeX(maxX);
        locY = rangeY(maxY);
        textHandles = addLabels(labels(contourPlotted),[locX(contourPlotted)',locY(contourPlotted)'],'center','bottom');
    end
end

end


