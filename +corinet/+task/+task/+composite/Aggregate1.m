classdef Aggregate1 < corinet.task.task.base.Composite
    
    %AGGREGATE1 Generic composite task aggregating results
    %in the context input variable of the generate function
    
    methods
        %
        % CONSTRUCTOR
        %
        function obj = Aggregate1(taskMaker)
            obj = obj@corinet.task.task.base.Composite(taskMaker);
            for i=1:numel(taskMaker.inportNames)
                addComponentName(obj,'inport',taskMaker.inportNames{i});
            end
            for i=1:numel(taskMaker.outportNames)
                addComponentName(obj,'outport',taskMaker.outportNames{i});
            end
        end
        %
        % LOAD/SAVE functionality
        %
        function s = saveobj(obj)
            s = saveobj@corinet.task.task.base.Composite(obj);
        end
        function obj = reload(obj,s)
            obj = reload@corinet.task.task.base.Composite(obj,s);
        end 
    end
    
    methods (Static = true)
        %
        % LOAD/SAVE functionality
        %
        function obj = loadobj(s)
            obj = corinet.task.task.composite.Aggregate1(s);
            obj = reload(obj,s);
        end    
    end
    
    methods
        function context = generate(obj,context)
            connectionsFromMainTask = getConnectionsFrom(obj,obj.ID);
            for c=1:numel(connectionsFromMainTask)
                connection = connectionsFromMainTask{c};
                context.(connection.toID).(connection.toPort) = context.(connection.fromPort);
            end
            for t=1:obj.numTasks
                tName = obj.taskIDs{t};
                context.(tName) = generate(getTask(obj,tName),context.(tName));
                connectionsFromTask = getConnectionsFrom(obj,tName);
                for c=1:numel(connectionsFromTask)
                    connection = connectionsFromTask{c};
                    if ~isfield(context,connection.toID) || ~isfield(context.(connection.toID),connection.toPort)
                        context.(connection.toID).(connection.toPort) = context.(tName).(connection.fromPort);
                    else
                        %combine patterns from different sources into 1 port
                        existingSet = context.(connection.toID).(connection.toPort);
                        newSet = context.(tName).(connection.fromPort);
                        tempResult = cell(size(existingSet));
                        for p=1:numel(existingSet)
                            tempResult{p} = vertcat(existingSet{p}(:),newSet{p}(:));
                        end
                        context.(connection.toID).(connection.toPort) = tempResult;
                    end
                end
            end
            connectionsToMainTask = fieldnames(context.(obj.ID));
            for c=1:numel(connectionsToMainTask)
                context.(connectionsToMainTask{c}) = context.(obj.ID).(connectionsToMainTask{c});
            end
            context = rmfield(context,obj.ID);
        end
    end
end

    

