function rsult = determineBlocksToReset(blockExecStructs)

%DETERMINEBLOCKSTORESET Helper function to transform information in
%blockExecStructs into boolean arrray that is easier to navigate during network
%execution.
% function rsult = determineBlocksToReset(blockExecStructs)


numExecs = numel(blockExecStructs);
rsult = false(1,numExecs);

for i = 1:numExecs
    rsult(i) = isfield(blockExecStructs{i},'reset');
end

end