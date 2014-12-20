classdef GenerationStructureBased < corinet.task.generator.base.PatternGenerator
    
    %GENERATIONSTRUCTUREBASED Base class for pattern generators that generate
    %patterns by using a "generation structure" (similar to execution
    %structure in networks).
    
    properties (SetAccess = private)
        fGenerate
    end
    
    methods
        function obj = GenerationStructureBased(generatorMaker)
            obj = obj@corinet.task.generator.base.PatternGenerator(generatorMaker);
            obj.fGenerate = str2func(generatorMaker.generate);
        end
        %
        % LOAD/SAVE functionality
        %
        function s = saveobj(obj)
            s = saveobj@corinet.task.generator.base.PatternGenerator(obj);
            s.generate = func2str(obj.fGenerate);
        end
        function obj = reload(obj,s)
            obj = reload@corinet.task.generator.base.PatternGenerator(obj,s);
        end
    end
    
    methods
        %
        % EXECUTE functionality
        %
        function gStruct = createGenerationStructure(obj)
            gStruct.generate = obj.fGenerate;
            for i=1:numel(obj.paramNames)
                gStruct.(obj.paramNames{i}) = obj.params.(obj.paramNames{i});
            end
        end 
    end
end

