function rsult = determineResponseToRecord(context,blockExecStructs,blockIDs)

%DETERMINERESPONSETORECORD Helper function to transform information from
%context struct into cell arrray that is easier to navigate during network
%execution.
% function rsult = determineResponseToRecord(context,blockExecStructs,blockIDs)
% context: struct with a field for each block from which internal signals
% or output signals should be recorded

numExecs = numel(blockExecStructs);
rsult = cell(1,numExecs);

recordIDs = fieldnames(context);
[dummy1,recordBlockIndices] = ismember(recordIDs,blockIDs); %#ok<ASGLU>
for i = 1:numel(recordBlockIndices)
    rsult{recordBlockIndices(i)} = context.(recordIDs{i});
end

end