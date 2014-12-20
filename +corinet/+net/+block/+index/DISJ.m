classdef DISJ < corinet.net.block.base.IndexBased
    
    %DISJ A DISJ block for disjunctive integration
    %For use in BlockNodePool networks
    
    properties (Dependent = true)
        numNodes
    end
        
    methods
        %
        % CONSTRUCTOR
        %
        function obj = DISJ(blockMaker)
            obj = obj@corinet.net.block.base.IndexBased(blockMaker);
            addComponentName(obj,'inport','X');
            addComponentName(obj,'outport','Y');
            addComponentName(obj,'weights','W');
            setOutportWidth(obj,'Y',blockMaker.numNodes);
        end
        %
        % LOAD/SAVE functionality
        %
        function s = saveobj(obj)
            s = saveobj@corinet.net.block.base.IndexBased(obj);
            s.numNodes = obj.numNodes;
        end
        function obj = reload(obj,s)
            obj = reload@corinet.net.block.base.IndexBased(obj,s);
        end
    end
    
    methods (Static = true)
        %
        % LOAD/SAVE functionality
        %
        function obj = loadobj(s)
            obj = corinet.net.block.index.DISJ(s);
            obj = reload(obj,s);
        end
    end
    
    methods
        %
        % GET/SET functionality
        %
        function rsult = get.numNodes(obj)
            rsult = getPortSize(obj,'Y');
        end
    end
    
    methods
        %
        % BUILD functionality
        %
        function setWeightsInitializer(obj,weightsName,initializer)
            setWeightsInitializer@corinet.net.block.base.IndexBased(obj,weightsName,initializer);
        end
    end  
    
    methods
        %
        % EXECUTE functionality
        %
        function eStruct = createExecutionStructure(obj)
            eStruct = createExecutionStructure@corinet.net.block.base.IndexBased(obj);
            eStruct.W = initialize(getWeightsInitializer(obj,'W'),obj.numNodes,getPortSize(obj,'X'));
            eStruct.WP = normMax(eStruct.W,1).*(normMax(eStruct.W',1))';
            if hasLearn(obj,'W') 
                eStruct.learn.W = getLearn(obj,'W');
            end
        end
    end
end



