classdef SingleMatrix < corinet.net.init.Initializer
    
    %PCBCWEIGHTS Abstract base class for single weight matrix initializers
    
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
        W = initialize(obj,numNodes,numInputs)
    end
end

