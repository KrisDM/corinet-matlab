classdef Normal < corinet.net.init.weights.base.SingleMatrix
    
    %NORMAL Initialize W to random normal values
    
    properties
        mean;
        std;
    end
    
    methods
        %
        % CONSTRUCTOR
        %
        function obj = Normal(initMaker)
            obj.mean = initMaker.mean;
            obj.std = initMaker.std;
        end
        %
        % LOAD/SAVE functionality
        %
        function s = saveobj(obj)
            s = saveobj@corinet.net.init.weights.base.SingleMatrix(obj);
            s.mean = obj.mean;
            s.std = obj.std;
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
            obj = corinet.net.init.weights.single.Normal(s);
            obj = reload(obj,s);
        end
    end 
    
    methods
        %
        % EXECUTE functionality
        %
        function W = initialize(obj,numNodes,numInputs)
            W = initNormal(numNodes,numInputs,obj.mean,obj.std);
        end
    end
end

