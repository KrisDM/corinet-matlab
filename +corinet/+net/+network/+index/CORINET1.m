classdef CORINET1 < corinet.net.network.base.BlockNodePool
    
    %CORINET1 Corinet network
    
    methods
        %
        % CONSTRUCTOR
        %
        function obj = CORINET1(netMaker)
            obj = obj@corinet.net.network.base.BlockNodePool(netMaker);
        end
        %
        % LOAD/SAVE functionality
        %
        function s = saveobj(obj)
            s = saveobj@corinet.net.network.base.BlockNodePool(obj);
        end
        function obj = reload(obj,s)
            obj = reload@corinet.net.network.base.BlockNodePool(obj,s);
        end
    end
    
    methods (Static = true)
        %
        % LOAD/SAVE functionality
        %
        function obj = loadobj(s)
            obj = corinet.net.network.index.CORINET1(s);
            obj = reload(obj,s);
        end    
    end
    
    methods
        %
        % EXECUTE functionality
        %
        function context = execute(obj,context)
            [obj.netExecutionStructure,obj.blockExecutionStructures,context] = ...
                context.execute(obj.netExecutionStructure,obj.blockExecutionStructures,...
                                context,obj.blockIDs);
        end
    end
end



