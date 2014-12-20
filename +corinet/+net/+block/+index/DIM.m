classdef DIM < corinet.net.block.base.IndexBased
    
    %DIM A DIM block with error and prediction nodes
    %For use in BlockNodePool networks
    
    properties (Dependent = true)
        numPredictionNodes
        numErrorNodes
    end
        
    methods
        %
        % CONSTRUCTOR
        %
        function obj = DIM(blockMaker)
            obj = obj@corinet.net.block.base.IndexBased(blockMaker);
            addComponentName(obj,'inport','X');
            addComponentName(obj,'outport','Y');
            addComponentName(obj,'weights','W');
            addComponentName(obj,'weights','V');
            addComponentName(obj,'internal','E');
            addComponentName(obj,'weightsCombination','DIM');
            setOutportWidth(obj,'Y',blockMaker.numPredictionNodes);
        end
        %
        % LOAD/SAVE functionality
        %
        function s = saveobj(obj)
            s = saveobj@corinet.net.block.base.IndexBased(obj);
            s.numPredictionNodes = obj.numPredictionNodes;
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
            obj = corinet.net.block.index.DIM(s);
            obj = reload(obj,s);
        end
    end
    
    methods
        %
        % GET/SET functionality
        %
        function rsult = get.numPredictionNodes(obj)
            rsult = getPortSize(obj,'Y');
        end
        function rsult = get.numErrorNodes(obj)
            rsult = getPortSize(obj,'X');
        end
    end
    
    methods
        %
        % BUILD functionality
        %
        function setWeightsInitializer(obj,weightsName,initializer)
            if strcmp(weightsName,'DIM') && ~isa(initializer,'corinet.net.init.weights.base.DoubleMatrix')
                ME = MException('Block:InvalidInitializer',...
                    '''%s'' is not a valid subtype of ''corinet.net.init.weights.base.DoubleMatrix''.',class(initializer));
                throw(ME);
            end
            setWeightsInitializer@corinet.net.block.base.IndexBased(obj,weightsName,initializer);
        end
    end  
    
    methods
        %
        % EXECUTE functionality
        %
        function eStruct = createExecutionStructure(obj)
            eStruct = createExecutionStructure@corinet.net.block.base.IndexBased(obj);
            eStruct.E = zeros(numel(eStruct.Xi),1);
            if hasWeightsInitializer(obj,'DIM')
                [eStruct.W,eStruct.V] = initialize(obj.getWeightsInitializer('DIM'),obj.numPredictionNodes,obj.numErrorNodes);
            else
                if hasWeightsInitializer(obj,'W')
                    eStruct.W = initialize(obj.getWeightsInitializer('W'),obj.numPredictionNodes,obj.numErrorNodes);
                end
                if hasWeightsInitializer(obj,'V')
                    eStruct.V = initialize(obj.getWeightsInitializer('V'),obj.numErrorNodes,obj.numPredictionNodes);
                end
            end
            if hasLearn(obj,'DIM')
                eStruct.learn.DIM = getLearn(obj,'DIM');
            else
                if hasLearn(obj,'W') 
                    eStruct.learn.W = getLearn(obj,'W');
                end
                if hasLearn(obj,'V')
                    eStruct.learn.V = getLearn(obj,'V');
                end
            end       
        end
    end
end



