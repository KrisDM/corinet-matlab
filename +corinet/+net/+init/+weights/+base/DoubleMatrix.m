classdef DoubleMatrix < corinet.net.init.Initializer
    
    %DOUBLEMATRIX Abstract base class for initializing two interdependent 
    %weight matrices.
    
    methods
        %
        % LOAD/SAVE functionality
        %
        function s = saveobj(obj)
            s = saveobj@corinet.net.init.Initializer(obj);
        end
        function obj = reload(obj,s)
            obj = reload@corinet.net.init.Initializer(obj,s);
        end
    end
    
    methods (Abstract)
        %
        % EXECUTE functionality
        %
        [W1,W2] = initialize(obj,numNodes,numInputs)
    end
end

