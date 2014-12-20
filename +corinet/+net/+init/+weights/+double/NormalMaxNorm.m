classdef NormalMaxNorm < corinet.net.init.weights.base.DoubleMatrix
    
    %NORMALMAXNORM Initialize W to random normal values and V to a max-normalized copy of W
    
    properties
        mean;
        std;
        psi;
    end
    
    methods
        %
        % CONSTRUCTOR
        %
        function obj = NormalMaxNorm(initMaker)
            obj.mean = initMaker.mean;
            obj.std = initMaker.std;
            obj.psi = initMaker.psi;
        end
        %
        % LOAD/SAVE functionality
        %
        function s = saveobj(obj)
            obj = saveobj@corinet.net.init.weights.base.DoubleMatrix(obj);
            s.mean = obj.mean;
            s.std = obj.std;
            s.psi = obj.psi;
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
            obj = corinet.net.init.weights.double.NormalMaxNorm(s);
            obj = reload(obj,s);
        end
    end 
    
    methods
        %
        % EXECUTE functionality
        %
        function [W,V] = initialize(obj,numNodes,numInputs)
            W = initNormal(numNodes(1),numInputs(1),obj.mean,obj.std);
            V = normMax(W,obj.psi)';
        end
    end
end

