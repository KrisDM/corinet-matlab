function [netExecStruct,blockExecStructs,context] = ...
    fullResponse1(netExecStruct,blockExecStructs,context,blockIDs)

%FULLRESPONSE1 Network execute function for use in BlockNodePool networks
% Records the full response of the network activity for each iteration
% netExecStruct: struct containing following fields
%   nodeValues: pool of activation values for all nodes in the network
%   inportNames: names of all inports to the network
%   (pName): indices for each inport
% blockExecStructs: cell array of structs containing following fields
%   activation: function handle to activation function
%   outportNames: names of all outports of the block
%   (oName): values for each outport
%   (oName)i: indices for each outport
% context: struct containing following fields:
%   (pName): input values for each inport, cell array with cell for each iteration
%   steps: number of steps to each iteration
%   record: struct with fields for each element to record
% blockIDs: cell array of blockIDs in same sequence as added


numBlocks = numel(blockExecStructs);
numIterations = numel(context.(netExecStruct.inportNames{1}));
nodeValues = netExecStruct.nodeValues;
resultsToRecord = determineResponseToRecord(context.record.inexecute.(netExecStruct.ID),blockExecStructs,blockIDs);
blocksToReset = determineBlocksToReset(blockExecStructs);

rsult = cell(numBlocks,1);
for e=1:numBlocks
    numRecord = numel(resultsToRecord{e});
    rsult{e} = cell(numRecord,1);
    for r=1:numRecord
        rsult{e}{r} = cell(numIterations,1);
    end
end

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
        %record activation
        if t == 1
            for e=1:numBlocks
                rNames = resultsToRecord{e};
                for r=1:numel(rNames)
                    thisRsult = blockExecStructs{e}.(rNames{r});
                    temp = zeros(numel(thisRsult),context.steps);
                    temp(:,1) = thisRsult;
                    rsult{e}{r}{i} = temp;
                end
            end
        else
            for e=1:numBlocks
                rNames = resultsToRecord{e};
                for r=1:numel(rNames)
                    rsult{e}{r}{i}(:,t) = blockExecStructs{e}.(rNames{r});
                end
            end
        end
    end
end

for e=1:numBlocks
    if ~isempty(resultsToRecord{e})
        context.results.inexecute.(netExecStruct.ID).(blockIDs{e}) = cell2struct(rsult{e},resultsToRecord{e},1);
    end
end

netExecStruct.nodeValues = nodeValues;

end