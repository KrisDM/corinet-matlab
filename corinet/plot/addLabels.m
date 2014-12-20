function textHandles = addLabels(labels,locations,hAlign,vAlign)

%addLabels Add labels to individual graphs on a plot

numLabels = size(locations,1);
numDims = size(locations,2);
textHandles = zeros(numLabels,1);

if isnumeric(labels)
    labelType = 1;
elseif islogical(labels)
    labelType = 2;
elseif ischar(labels)
    labelType = 3;
elseif iscell(labels)
    labelType = 4;
end

X = locations(:,1);
Y = locations(:,2);
if numDims == 3
    Z = locations(:,3);
end

for j=1:numLabels,
    switch labelType
        case 1,
            labelStr = num2str(labels(j));
        case 2,
            if labels(j)
                labelStr = num2str(j);
            else
                labelStr = '';
            end
        case 3,
            labelStr = labels(j,:);
        case 4,
            labelStr = labels{j};
    end
    if ~isempty(labelStr)
        switch numDims
            case 2,
                textHandles(j) = text(X(j),Y(j),labelStr,...
                    'HorizontalAlignment',hAlign,'VerticalAlignment',vAlign);
            case 3,
                textHandles(j) = text(X(j),Y(j),Z(j),labelStr,...
                    'HorizontalAlignment',hAlign,'VerticalAlignment',vAlign);
        end
    end
end

end

