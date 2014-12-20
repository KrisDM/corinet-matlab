classdef Values1 < corinet.task.generator.base.GenerationStructureBased
 
    %VALUES1 Generating a set of values according to the specified generate function
    
    methods
        %
        % CONSTRUCTOR
        %
        function obj = Values1(generatorMaker)
            obj = obj@corinet.task.generator.base.GenerationStructureBased(generatorMaker);
        end
        %
        % LOAD/SAVE functionality
        %
        function s = saveobj(obj)
            s = saveobj@corinet.task.generator.base.GenerationStructureBased(obj);
        end
        function obj = reload(obj,s)
            obj = reload@corinet.task.generator.base.GenerationStructureBased(obj,s);
        end
    end
    
    methods (Static = true)
        %
        % LOAD/SAVE functionality
        %
        function obj = loadobj(s)
            obj = corinet.task.generator.simple.Values1(s);
            obj = reload(obj,s);
        end
    end
    
    methods
        %
        % EXECUTE functionality
        %
        function gStruct = createGenerationStructure(obj)
            gStruct = createGenerationStructure@corinet.task.generator.base.GenerationStructureBased(obj);
        end
        function rsult = generate(obj,in)
            % function rsult = generate(obj,varargin)
            %   in: input argument depends on generate function
            % rsult: simply passed on from generate function, not processed
            S = createGenerationStructure(obj);
            rsult = S.generate(S,in{:});
        end  
    end
end

