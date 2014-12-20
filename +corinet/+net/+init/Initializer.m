classdef Initializer < handle
    
    %INITIALIZER Abstract base class for initializers
    
    methods
        %
        % LOAD/SAVE functionality
        %
        function s = saveobj(obj)
            s.className = class(obj);
        end
        function obj = reload(obj,dummy1) %#ok<INUSD>
            %reload does nothing
        end
    end
    
    methods (Abstract)
        %
        % EXECUTE functionality
        %
        rsult = initialize(obj)
    end
end

