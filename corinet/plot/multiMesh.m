function [meshHandles,textHandles] = multiMesh(rangeX,rangeY,values,labels)

%MULTIMESH Plot multiple meshes in same plot, adding mesh labels

numMeshes = size(values,1);
numDims = ndims(values);
numX = length(rangeX);
numY = length(rangeY);
meshHandles = zeros(numMeshes,1);

if numMeshes
    for j=1:numMeshes,
        switch numDims
            case 2,
                meshHandles(j) = mesh(rangeX,rangeY,reshape(values(j,:),numX,numY));
            case 3,
                meshHandles(j) = mesh(rangeX,rangeY,squeeze(values(j,:,:)));
        end
        hold on;
    end
    if nargin == 4
        maxX = zeros(numMeshes,1);
        maxY = zeros(numMeshes,1);
        maxZ = zeros(numMeshes,1);
        for j=1:numMeshes,
            [maxZ(j),maxIndex] = max(values(j,:));
            [maxX(j),maxY(j)] = ind2sub(numX,numY,maxIndex);
        end
        textHandles(j) = addLabels(labels,[maxX,maxY,maxZ],'center','bottom');
    end
end

end
       

