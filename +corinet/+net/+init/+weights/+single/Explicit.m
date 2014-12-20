classdef Explicit < corinet.net.init.weights.base.SingleMatrix
    
    %Explicit Initialize W to explicit weight values
    
    properties
        values;
    end
    
    methods
        %
        % CONSTRUCTOR
        %
        function obj = Explicit(initMaker)
            obj.values = initMaker.values;
        end
        %
        % LOAD/SAVE functionality
        %
        function s = saveobj(obj)
            s = saveobj@corinet.net.init.weights.base.SingleMatrix(obj);
            s.values = obj.values;
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
            obj = corinet.net.init.weights.single.Explicit(s);
            obj = reload(obj,s);
        end
    end 
    
    methods
        %
        % EXECUTE functionality
        %
        function W = initialize(obj,numNodes,numInputs)
            if ~all([numNodes,numInputs] == size(obj.values))
                ME = MException('Initializer:Explicit','Dimension mismatch');
                throw(ME);
            end
            W = obj.values;
        end
    end
end

