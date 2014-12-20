classdef Task < handle
    
    %TASK Abstract base class for tasks
    
    properties (SetAccess = private)
        ID
    end
    properties (SetAccess = private)
        inportNames = {}
        outportNames = {}
        paramNames = {}
    end
    properties
        params
    end
    
    methods
        %
        % CONSTRUCTOR
        %
        function obj = Task(taskMaker)
            if ~isa(taskMaker.ID,'char')
                ME = MException('Task:ID','Task ID should be of type ''char''');
                throw(ME);
            end
            obj.ID = taskMaker.ID;
            if isfield(taskMaker,'params')
                obj.params = taskMaker.params;
                obj.paramNames = fieldnames(taskMaker.params)';
            end
        end
        %
        % LOAD/SAVE functionality
        %
        function s = saveobj(obj)
            s.ID = obj.ID;
            s.className = class(obj);
            s.inportNames = obj.inportNames;
            s.outportNames = obj.outportNames;
            if ~isempty(obj.params)
                s.params = obj.params;
            end
        end
        function obj = reload(obj,dummy1) %#ok<INUSD>
            %reload does nothing
        end
    end
    
    methods
        %
        % EXECUTE functionality
        %
        function context = reset(obj,context)
            context = rmfield(context,obj.outportNames);
        end
    end
    
    methods (Abstract)
        %
        % EXECUTE functionality
        %
        context = generate(obj,context)
    end
    
    methods (Access = protected, Hidden = true)
        %
        % HELPER functionality
        %
        function addComponentName(obj,compType,compName)
            i_checkDuplicate(horzcat(obj.inportNames,obj.outportNames),compName);
            switch compType
                case 'inport'
                    obj.inportNames{end+1} = compName;
                case 'outport'
                    obj.outportNames{end+1} = compName;
            end
        end
    end
end

function i_checkDuplicate(compSet,compName)

if any(ismember(compSet,compName))
    ME = MException('Task:PortAlreadyIn','A port with name ''%s'' already exists in this task.',compName);
    throw(ME);
end

end

