classdef PCBCB < corinet.net.block.index.DIM
    
    %PCBCB A PC/BC block of nodes, derived from the DIM block and
    %adding feedback input ports and weights. Only use when 
    %feedback weights are meant to be learned 
    
    properties (SetAccess = private, Hidden)
        feedback
    end
    
    methods
        %
        % CONSTRUCTOR
        %
        function obj = PCBCB(blockMaker)
            obj = obj@corinet.net.block.index.DIM(blockMaker);
            obj.feedback = blockMaker.feedback;
            for fb=blockMaker.feedback
                addComponentName(obj,'inport',fb.inportName);
                addComponentName(obj,'weights',fb.weightsName);
            end
            addComponentName(obj,'weightsCombination','PCBC');
        end
        %
        % LOAD/SAVE functionality
        %
        function s = saveobj(obj)
            s = saveobj@corinet.net.block.index.DIM(obj);
            s.feedback = obj.feedback;
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
            obj = corinet.net.block.index.PCBCB(s);
            obj = reload(obj,s);
        end
    end
    
    methods
        %
        % BUILD functionality
        %
        function setWeightsInitializer(obj,weightsName,initializer)
            if strcmp(weightsName,'PCBC') && ~isa(initializer,'corinet.net.init.weights.base.SingleMatrix')
                ME = MException('Block:InvalidInitializer',...
                    '''%s'' is not a valid subtype of ''corinet.net.init.weights.base.SingleMatrix''.',class(initializer));
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
            eStruct.feedback = obj.feedback;
            if hasWeightsInitializer(obj,'PCBC')
                weightsInitializer = getWeightsInitializer(obj,'PCBC');
                eStruct.W = initialize(weightsInitializer,obj.numPredictionNodes,obj.numErrorNodes);
                eStruct.V = initialize(weightsInitializer,obj.numErrorNodes,obj.numPredictionNodes);
                for fb=obj.feedback,
                    eStruct.(fb.weightsName) = initialize(weightsInitializer,obj.numPredictionNodes,getPortSize(obj,fb.inportName));
                end
            else
                for fb=obj.feedback,
                    eStruct.(fb.weightsName) = initialize(getWeightsInitializer(obj,fb.weightsName),...
                        obj.numPredictionNodes,getPortSize(obj,fb.inportName));
                end
            end
            if hasLearn(obj,'PCBC')
                eStruct.learn.PCBC = getLearn(obj,'PCBC');
            else
                for fb=obj.feedback
                    if hasLearn(obj,fb.weightsName)
                        eStruct.learn.(fb.weightsName) = getLearn(obj,fb.weightsName);
                    end
                end
            end
        end
    end
end


