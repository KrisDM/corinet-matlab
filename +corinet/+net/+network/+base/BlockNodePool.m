classdef BlockNodePool < corinet.net.network.base.BlockBased
    
    %BLOCKNODEPOOL A block-based network indexing a node pool
    
    properties (SetAccess = private, GetAccess = private, Hidden)
        currentNodePoolSize = 0
    end
    properties (SetAccess = private, GetAccess = private, Hidden)
        portToIndex
        inportToWidth
    end
    properties (SetAccess = private, GetAccess = private, Hidden)
        idToBlockExecutionStructure
    end
    properties (Access = protected, Hidden)
        netExecutionStructure
    end
    properties (Dependent, Access = protected, Hidden)
        blockExecutionStructures
    end
    
    methods
        %
        % CONSTRUCTOR
        %
        function obj = BlockNodePool(netMaker)
            obj = obj@corinet.net.network.base.BlockBased(netMaker);
            obj.portToIndex = containers.Map;
            obj.inportToWidth = containers.Map;
            for i=1:numel(netMaker.inportNames)
                addComponentName(obj,'inport',netMaker.inportNames{i},netMaker.inportWidths(i));
            end
            for i=1:numel(netMaker.outportNames)
                addComponentName(obj,'outport',netMaker.outportNames{i});
            end
            obj.idToBlockExecutionStructure = containers.Map;
        end
        %
        % LOAD/SAVE functionality
        %
        function s = saveobj(obj)
            s = saveobj@corinet.net.network.base.BlockBased(obj);
            s.inportWidths = cell2mat(values(obj.inportToWidth,obj.inportNames));
            s.portToIndex = obj.portToIndex;
            s.currentNodePoolSize = obj.currentNodePoolSize;
            s.netExecutionStructure = obj.netExecutionStructure;
            s.blockExecutionStructures = values(obj.idToBlockExecutionStructure,obj.blockIDs);
        end
        function obj = reload(obj,s)
            obj = reload@corinet.net.network.base.BlockBased(obj,s);
            obj.portToIndex = s.portToIndex;
            obj.currentNodePoolSize = s.currentNodePoolSize;
            obj.netExecutionStructure = s.netExecutionStructure;
            for i=1:numel(s.blockExecutionStructures) 
                obj.idToBlockExecutionStructure(obj.blockIDs{i}) = s.blockExecutionStructures{i};
            end
        end
        %
        % GET/SET functionality
        %
        function rsult = get.blockExecutionStructures(obj)
            rsult = values(obj.idToBlockExecutionStructure,obj.blockIDs);
        end
        function set.blockExecutionStructures(obj,values)
            for i=1:obj.numBlocks
                obj.idToBlockExecutionStructure(obj.blockIDs{i}) = values{i};
            end
        end
    end
    
    methods 
        %
        % BUILD functionality
        %
        function addBlock(obj,block)
            if ~isa(block,'corinet.net.block.base.IndexBased')
                ME = MException('Network:NotABlock','''%s'' should be a subtype of ''corinet.net.block.base.IndexBased''.',class(block));
                throw(ME);
            end
            addBlock@corinet.net.network.base.BlockBased(obj,block);
            rT = obj.currentNodePoolSize;
            for i=1:numel(block.outportNames)
                oN = block.outportNames{i};
                oW = getOutportWidth(block,oN);
                addPortIndex(block,oN,rT+1:rT+oW);
                rT = rT + oW;
            end 
            obj.currentNodePoolSize = rT;
        end
        function connect(obj,s)
            if strcmp(s.fromID,obj.ID)
                i_checkName(obj.inportNames,'inport',s.fromPort);
                fromIndex = obj.portToIndex(s.fromPort);
            else
                fromBlock = getBlock(obj,s.fromID);
                i_checkName(fromBlock.outportNames,'outport',s.fromPort);
                fromIndex = getPortIndex(fromBlock,s.fromPort);
            end
            if strcmp(s.toID,obj.ID)
                i_checkName(obj.outportNames,'outport',s.toPort);
                obj.portToIndex(s.toPort) = horzcat(obj.portToIndex(s.toPort),fromIndex(:)');
            else
                toBlock = getBlock(obj,s.toID);
                i_checkName(toBlock.inportNames,'inport',s.toPort);
                addPortIndex(toBlock,s.toPort,fromIndex);
            end
        end  
    end
    
    methods
        %
        % EXECUTE functionality
        %
        function initialize(obj)
            obj.netExecutionStructure = createExecutionStructure(obj);
            for i=1:numel(obj.blockIDs)
                thisID = obj.blockIDs{i};
                obj.idToBlockExecutionStructure(thisID) = createExecutionStructure(getBlock(obj,thisID));
            end
        end
        function eStruct = createExecutionStructure(obj)
            eStruct.ID = obj.ID;
            eStruct.inportNames = obj.inportNames;
            eStruct.outportNames = obj.outportNames;
            for i=1:numel(eStruct.inportNames)
                iName = eStruct.inportNames{i};
                eStruct.(iName) = obj.portToIndex(iName);
            end
            for o=1:numel(eStruct.outportNames)
                oName = eStruct.outportNames{o};
                eStruct.(oName) = obj.portToIndex(oName);
            end
            eStruct.nodeValues = zeros(obj.currentNodePoolSize,1);
        end
        function rsult = getValues(obj,context)
            ids = fieldnames(context);
            for i=1:numel(ids)
                iName = ids{i};
                rNames = context.(iName);
                for r=1:numel(rNames)
                    rName = rNames{r};
                    rsult.(iName).(rName) = obj.idToBlockExecutionStructure(iName).(rName);
                end
            end
        end
    end
        
    methods (Access = protected, Hidden = true)
        %
        % HELPER functionality
        %
        function addComponentName(obj,compType,compName,portWidth)
            addComponentName@corinet.net.network.base.Network(obj,compType,compName);
            if strcmp(compType,'inport')
                obj.inportToWidth(compName) = portWidth;
                obj.portToIndex(compName) = obj.currentNodePoolSize+1:obj.currentNodePoolSize+portWidth;
                obj.currentNodePoolSize = obj.currentNodePoolSize + portWidth;
            else
                obj.portToIndex(compName) = [];
            end
        end 
    end
end

function i_checkName(compSet,compType,compName)

if ~ismember(compSet,compName)
    ME = MException('Network:UnknownName',...
        'Unknown %s name ''%s''.',compType,compName);
    throw(ME);
end

end