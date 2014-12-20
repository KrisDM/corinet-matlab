classdef Normal < corinet.net.init.weights.base.DoubleMatrix
    
    %NORMAL Initialize W and V to randomized, normal values
    
    properties
        meanW
        stdW
        meanV
        stdV
    end
    
    methods
        %
        % CONSTRUCTOR
        %
        function obj = Normal(initMaker)
            obj.meanW = initMaker.meanW;
            obj.stdW = initMaker.stdW;
            obj.meanV = initMaker.meanV;
            obj.stdV = initMaker.stdV;
        end
        %
        % LOAD/SAVE functionality
        %
        function s = saveobj(obj)
            obj = saveobj@corinet.net.init.weights.base.DoubleMatrix(obj);
            s.meanW = obj.meanW;
            s.stdW = obj.stdW;
            s.meanV = obj.meanV;
            s.stdV = obj.stdV;
        end
        function obj = reload(obj,s)
            obj = reload@corinet.net.init.weights.base.DoubleMatrix(obj,s);
        end
    end
    
    methods (Static = true)
        %
        % LOAD/SAVE functionality
        %
        function obj = loadobj(s)
            obj = corinet.net.init.weights.double.Normal(s);
            obj = reload(obj,s);
        end
    end 
    
    methods
        %
        % EXECUTE functionality
        %
        function [W,V] = initialize(obj,numNodes,numInputs)
            W = initNormal(numNodes,numInputs,obj.meanW,obj.stdW);
            V = initNormal(numInputs,numNodes,obj.meanV,obj.stdV);
        end
    end
end

