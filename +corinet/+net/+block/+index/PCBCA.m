classdef PCBCA < corinet.net.block.index.DIM
    
    %PCBCA A PC/BC block of nodes, derived from the DIM block and
    %adding feedback outports and widths. Only use when the external
    %feedback weights are scaled/transposed copies of W weights
    
    properties (SetAccess = private, Hidden)
        iFeedback
        oFeedback
    end
    
    methods
        %
        % CONSTRUCTOR
        %
        function obj = PCBCA(blockMaker)
            obj = obj@corinet.net.block.index.DIM(blockMaker);
            obj.iFeedback = blockMaker.iFeedback;
            obj.oFeedback = blockMaker.oFeedback;
            for ifb=blockMaker.iFeedback
                addComponentName(obj,'inport',ifb.inportName);
            end
            for ofb=blockMaker.oFeedback
                addComponentName(obj,'outport',ofb.outportName);
                setOutportWidth(obj,ofb.outportName,numel(ofb.Ui));
            end
            addComponentName(obj,'weights','U');
            addComponentName(obj,'weightsCombination','PCBC');
        end
        %
        % LOAD/SAVE functionality
        %
        function s = saveobj(obj)
            s = saveobj@corinet.net.block.index.DIM(obj);
            s.iFeedback = obj.iFeedback;
            s.oFeedback = obj.oFeedback;
        end
        function obj = reload(obj,s)
            obj = reload@corinet.net.block.index.DIM(obj,s);
        end
    end
    
    methods (Static = true)
        %
        % LOAD/SAVE functionality
        %
        function obj = loadobj(s)
            obj = corinet.net.block.index.PCBCA(s);
            obj = reload(obj,s);
        end
    end
    
    methods
        %
        % BUILD functionality
        %
        function setWeightsInitializer(obj,weightsName,initializer)
            if strcmp(weightsName,'PCBC') && ~isa(initializer,'corinet.net.init.weights.base.DoubleMatrix')
                ME = MException('Block:InvalidInitializer',...
                    '''%s'' is not a valid subtype of ''corinet.net.init.weights.base.DoubleMatrix''.',class(initializer));
                throw(ME);
            end
            setWeightsInitializer@corinet.net.block.index.DIM(obj,weightsName,initializer);
        end
    end  
    
    methods
        %
        % EXECUTE functionality
        %
        function eStruct = createExecutionStructure(obj)
            eStruct = createExecutionStructure@corinet.net.block.index.DIM(obj);
            eStruct.iFeedback = obj.iFeedback;
            eStruct.oFeedback = obj.oFeedback;
            if hasWeightsInitializer(obj,'PCBC')
                [eStruct.W,eStruct.V] = initialize(obj.getWeightsInitializer('PCBC'),obj.numPredictionNodes,obj.numErrorNodes);
                eStruct.U = eStruct.V;
            else
                if hasWeightsInitializer(obj,'U')
                    eStruct.U = initialize(obj.getWeightsInitializer('U'),obj.numPredictionNodes,obj.numErrorNodes);
                end
            end
            if hasLearn(obj,'PCBC')
                eStruct.learn.PCBC = getLearn(obj,'PCBC');
            else
                if hasLearn(obj,'U') 
                    eStruct.learn.U = getLearn(obj,'U');
                end
            end
        end
    end
end


