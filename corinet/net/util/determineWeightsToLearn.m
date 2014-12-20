function rsult = determineWeightsToLearn(context,blockExecStructs,blockIDs)

%DETERMINEWEIGHTSTOLEARN Helper function to transform information in
%context struct into cell arrray that is easier to navigate during network
%execution.
% function rsult = determineWeightsToLearn(context,blockExecStructs,blockIDs)
% context: either a boolean, learn all weights with a learning rule;
%          or a struct with a field for each ID, containing a list of
%          weight names to be learned

numExecs = numel(blockExecStructs);
rsult = cell(1,numExecs);
if ~islogical(context)
    learnIDs = fieldnames(context);
    [dummy1,learnBlockIndices] = ismember(learnIDs,blockIDs); %#ok<ASGLU>
    for i = 1:numel(learnBlockIndices)
        rsult{learnBlockIndices(i)} = context.(learnIDs{i});
    end
elseif context
    for i = 1:numel(blockIDs)
        thisExec = blockExecStructs{i};
        if isfield(thisExec,'learn')
            rsult{i} = fieldnames(thisExec.learn);
        end
    end
end

end