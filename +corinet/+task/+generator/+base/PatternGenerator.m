classdef PatternGenerator < handle
    
    %PATTERNGENERATOR Base class for pattern generators
    
    properties (SetAccess = private)
        paramNames = {}
    end
    properties
        params
    end
    
    methods
        function obj = PatternGenerator(generatorMaker)
            if isfield(generatorMaker,'params')
                obj.params = generatorMaker.params;
                obj.paramNames = fieldnames(generatorMaker.params)';
            end
        end
        %
        % LOAD/SAVE functionality
        %
        function s = saveobj(obj)
            s.className = class(obj);
            if ~isempty(obj.params)
                s.params = obj.params;
            end
        end
        function obj = reload(obj,dummy1) %#ok<INUSD>
            %do nothing
        end
    end
    
    methods (Abstract)
        %
        % EXECUTE functionality
        %
        rsult = generate(obj,in)
    end
end

