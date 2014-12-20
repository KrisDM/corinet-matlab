classdef IndexBased < corinet.net.block.base.Block
    
    %INDEXBASED Base type for blocks to be used with BlockNodePool networks
    
    properties (SetAccess = private, GetAccess = private, Hidden)
        portToIndex
        outportToWidth
        plotToCommand
    end
    
    methods
        %
        % CONSTRUCTOR
        %
        function obj = IndexBased(blockMaker)
            obj = obj@corinet.net.block.base.Block(blockMaker);
            obj.portToIndex = containers.Map;
            obj.outportToWidth = containers.Map;
            obj.plotToCommand = containers.Map;
        end
        %
        % LOAD/SAVE functionality
        %
        function s = saveobj(obj)
            s = saveobj@corinet.net.block.base.Block(obj);
            s.portToIndex = obj.portToIndex;
            s.outportToWidth = obj.outportToWidth;
        end  
        function obj = reload(obj,s)
            obj = reload@corinet.net.block.base.Block(obj,s); 
            obj.portToIndex = s.portToIndex; 
            obj.outportToWidth = s.outportToWidth;
        end
    end
    
    methods 
        %
        % BUILD functionality
        %
        function addPortIndex(obj,portName,index)
            i_checkName(horzcat(obj.inportNames,obj.outportNames),'port',portName);
            obj.portToIndex(portName) = horzcat(obj.portToIndex(portName),index(:)');
        end
        function rsult = getPortIndex(obj,portName)
            i_checkName(horzcat(obj.inportNames,obj.outportNames),'port',portName);
            rsult = obj.portToIndex(portName);
        end
        function rsult = getPortSize(obj,portName)
            i_checkName(horzcat(obj.inportNames,obj.outportNames),'port',portName);
            rsult = numel(obj.portToIndex(portName));
        end
        function setOutportWidth(obj,portName,width)
            i_checkName(obj.outportNames,'outport',portName);
            obj.outportToWidth(portName) = width;
        end
        function rsult = getOutportWidth(obj,portName)
            i_checkName(obj.outportNames,'outport',portName);
            rsult = obj.outportToWidth(portName);
        end
    end
    
    methods
        %
        % EXECUTE functionality
        %
        function eStruct = createExecutionStructure(obj)
            eStruct.inportNames = obj.inportNames;
            for i=1:numel(obj.inportNames)
                iName = obj.inportNames{i};
                eStruct.([iName 'i']) = getPortIndex(obj,iName);
            end
            eStruct.outportNames = obj.outportNames;
            for i=1:numel(obj.outportNames)
                oName = obj.outportNames{i};
                eStruct.([oName 'i']) = getPortIndex(obj,oName);
                eStruct.(oName) = zeros(getPortSize(obj,oName),1);
            end
            eStruct.internalNames = obj.internalNames;
            for i=1:numel(obj.internalNames)
                iName = obj.internalNames{i};
                eStruct.(iName) = [];
            end
            eStruct.weightsNames = obj.weightsNames;
            for i=1:numel(obj.weightsNames)
                wName = obj.weightsNames{i};
                eStruct.(wName) = [];
            end
            eStruct.paramNames = obj.paramNames;
            for i=1:numel(obj.paramNames)
                pName = obj.paramNames{i};
                eStruct.(pName) = obj.params.(pName);
            end
            if hasActivation(obj)
                eStruct.activation = getActivation(obj);
            end
            if hasReset(obj)
                eStruct.reset = getReset(obj);
            end
            if hasPlot(obj,'activation')
                eStruct.plot.activation = getPlot(obj,'activation');
            else
                eStruct.plot.activation = [];
            end
            if hasPlot(obj,'learn')
                eStruct.plot.learn = getPlot(obj,'learn');
            else
                eStruct.plot.learn = [];
            end
        end
    end
    
    methods (Access = protected, Hidden = true)
        %
        % HELPER functionality
        %
        function addComponentName(obj,compType,compName)
            addComponentName@corinet.net.block.base.Block(obj,compType,compName);
            if strcmp('outport',compType)
                obj.outportToWidth(compName) = 0;
            end
            if ismember(compType,{'inport','outport'})
                obj.portToIndex(compName) = [];
            end
        end   
    end
end
    
function i_checkName(compSet,compType,compName)

if ~ismember(compName,compSet)
    ME = MException('Block:UnknownName','Unknown %s name ''%s''.',compType,compName);
    throw(ME);
end

end

    



