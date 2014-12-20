classdef Composite < corinet.task.task.base.Task
    
    %COMPOSITE Task consisting of multiple tasks
    
    properties (SetAccess = private)
        taskIDs = {} %to keep them in the order as added
    end
    properties (Access = private, Hidden)
        idToTask
        idToConnections
    end
    properties (Dependent)
        numTasks
    end
    
    methods
        %
        % CONSTRUCTOR
        %
        function obj = Composite(taskMaker)
            obj = obj@corinet.task.task.base.Task(taskMaker);
            obj.idToTask = containers.Map;
            obj.idToConnections = containers.Map;
        end
        %
        % LOAD/SAVE functionality
        %
        function s = saveobj(obj)
            s = saveobj@corinet.task.task.base.Task(obj);
            tasks = values(obj.idToTask,obj.taskIDs);
            s.taskMakers = cell(1,numel(tasks)); 
            for i=1:numel(tasks)
                s.taskMakers{i} = saveobj(tasks{i});
            end
            connections = values(obj.idToConnections,obj.taskIDs);
            s.connections = horzcat(connections{:});
        end
        function obj = reload(obj,s)
            obj = reload@corinet.task.task.base.Task(obj,s);
            if isfield(s,'taskMakers')
                for i=1:numel(s.taskMakers)
                    fHandle = str2func(sprintf('%s.loadobj',s.taskMakers{i}.className));
                    addTask(obj,s.taskMakers{i}.ID,fHandle(s.taskMakers{i}));
                end
            end
            if isfield(s,'connections')
                for i=1:numel(s.connections)
                    connect(obj,s.connections{i});
                end
            end
        end 
        %
        % GET/SET functionality
        %
        function rsult = get.numTasks(obj)
            rsult = length(obj.idToTask);
        end
        %
        % BUILD functionality
        %
        function addTask(obj,task)
            if ~isa(task,'corinet.task.task.base.Task')
                ME = MException('Task:NotATask','''%s'' is not a valid subtype of ''corinet.task.task.base.Task''.',class(task));
                throw(ME);
            end
            if obj.idToTask.isKey(task.ID)
                ME = MException('Task:TaskAlreadyIn','A task with ID ''%s'' already exists in this task.',task.ID);
                throw(ME);
            end
            obj.taskIDs{end+1} = task.ID;
            obj.idToTask(task.ID) = task;
        end  
        function rsult = getTask(obj,taskID)
            if ~obj.idToTask.isKey(taskID)
                ME = MException('Task:UnknownTaskID','Unknown task ID ''%s''.',taskID);
                throw(ME);
            end
            rsult = obj.idToTask(taskID);
        end
        function connect(obj,s)
            if ~isKey(obj.idToConnections,s.fromID)
                obj.idToConnections(s.fromID) = {};
            end
            obj.idToConnections(s.fromID) = horzcat(obj.idToConnections(s.fromID),{s});
        end 
        %
        % EXECUTION functionality
        %
        function context = reset(obj,context)
            context = reset@corinet.task.task.base.Task(obj,context);
            tasks = values(obj.idToTask,obj.taskIDs);
            for t=1:numel(tasks)
                context.(tasks{t}.ID) = reset(tasks{t},context.(tasks{t}.ID));
            end
            context = rmfield(context,obj.taskIDs);
        end
        function rsult = getConnectionsFrom(obj,fromID)
            rsult = obj.idToConnections(fromID);
        end
    end
end

