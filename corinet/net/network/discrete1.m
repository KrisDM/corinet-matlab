function [netExecStruct,blockExecStructs,context] = ...
    discrete1(netExecStruct,blockExecStructs,context,blockIDs)

%DISCRETE1 Network execute function for use in BlockNodePool networks
% Weights are adjusted at the end of the entire integration.
% netExecStruct: struct containing following fields
%   nodeValues: pool of activation values for all nodes in the network
%   inportNames: names of all inports to the network
%   (pName): indices for each inport
% blockExecStructs: cell array of structs containing following fields
%   activation: function handle to activation function
%   outportNames: names of all outports of the block
%   (oName): values for each outport
%   (oName)i: indices for each outport
%   learn: a struct containing following fields:
%       (wName): function handle to learn function for each weight name
% context: struct containing following fields:
%   (pName): input values for each inport, cell array with cell for each iteration
%   numSteps: number of steps to each iteration
% blockIDs: cell array of blockIDs in same sequence as added

numBlocks = numel(blockExecStructs);
numIterations = numel(context.(netExecStruct.inportNames{1}));
nodeValues = netExecStruct.nodeValues;
weightsToLearn = determineWeightsToLearn(context.learn.(netExecStruct.ID),blockExecStructs,blockIDs);
blocksToReset = determineBlocksToReset(blockExecStructs);

for i=1:numIterations
    %set the input
    for p=1:numel(netExecStruct.inportNames)
        pName = netExecStruct.inportNames{p};
        nodeValues(netExecStruct.(pName)) = context.(pName){i}(:);
    end
    %reset the state of the block
    for e=1:numBlocks
        if blocksToReset(e)
            blockExecStructs{e} = blockExecStructs{e}.reset(blockExecStructs{e});
        end
        oNames = blockExecStructs{e}.outportNames;
        for o=1:numel(oNames)
            nodeValues(blockExecStructs{e}.([oNames{o} 'i'])) = blockExecStructs{e}.(oNames{o});
        end
    end  
    %calculate activation
    for t=1:context.steps
        for e=1:numBlocks
            blockExecStructs{e} = blockExecStructs{e}.activation(blockExecStructs{e},nodeValues);
        end
        for e=1:numBlocks
            oNames = blockExecStructs{e}.outportNames;
            for o=1:numel(oNames)
                nodeValues(blockExecStructs{e}.([oNames{o} 'i'])) = blockExecStructs{e}.(oNames{o});
            end
        end
    end
    for e=1:numBlocks
        wNames = weightsToLearn{e};
        for w=1:numel(wNames)
            blockExecStructs{e} = blockExecStructs{e}.learn.(wNames{w})(blockExecStructs{e},nodeValues,wNames{w});
        end
    end
end

netExecStruct.nodeValues = nodeValues;

end

