classdef Network < handle
    
    %Network Base class for networks
    
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
        function obj = Network(netMaker)
            if ~isa(netMaker.ID,'char')
                ME = MException('Network:ID','Network ID should be of type ''char''');
                throw(ME);
            end
            obj.ID = netMaker.ID;
            if isfield(netMaker,'params')
                obj.params = netMaker.params;
                obj.paramNames = fieldnames(netMaker.params)';
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
    
    methods (Abstract = true)
        %
        % EXECUTE functionality
        %
        initialize(obj)
        context = execute(obj,context)
        context = getValues(obj,context)
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
    ME = MException('Network:PortAlreadyIn','A port with name ''%s'' already exists in this network.',compName);
    throw(ME);
end

end

