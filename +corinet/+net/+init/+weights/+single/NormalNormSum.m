classdef NormalNormSum < corinet.net.init.weights.base.SingleMatrix
    
    %NORMAL Initialize W to random normal values and normalize sum to psi
    
    properties
        mean;
        std;
        psi;
    end
    
    methods
        %
        % CONSTRUCTOR
        %
        function obj = NormalNormSum(initMaker)
            obj.mean = initMaker.mean;
            obj.std = initMaker.std;
            obj.psi = initMaker.psi;
        end
        %
        % LOAD/SAVE functionality
        %
        function s = saveobj(obj)
            s = saveobj@corinet.net.init.weights.base.SingleMatrix(obj);
            s.mean = obj.mean;
            s.std = obj.std;
            s.psi = obj.psi;
        end
        function obj = reload(obj,s)
            obj = reload@corinet.net.init.weights.base.SingleMatrix(obj,s);
        end
    end
    
    methods (Static = true)
        %
        % LOAD/SAVE functionality
        %
        function obj = loadobj(s)
            obj = corinet.net.init.weights.single.NormalNormSum(s);
            obj = reload(obj,s);
        end
    end 
    
    methods
        %
        % EXECUTE functionality
        %
        function W = initialize(obj,numNodes,numInputs)
            W = initNormal(numNodes,numInputs,obj.mean,obj.std);
            W = normSum(W',obj.psi)';
        end
    end
end

