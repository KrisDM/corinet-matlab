classdef PopulationSignal1 < corinet.task.generator.base.GenerationStructureBased
 
    %POPULATIONSIGNAL1 Population signal generated for specific input values
    
    properties (SetAccess = private)
        fCombine
    end
    
    methods
        %
        % CONSTRUCTOR
        %
        function obj = PopulationSignal1(generatorMaker)
            obj = obj@corinet.task.generator.base.GenerationStructureBased(generatorMaker);
            if isfield(generatorMaker,'combine')
                obj.fCombine = str2func(generatorMaker.combine);   
            end
        end
        %
        % LOAD/SAVE functionality
        %
        function s = saveobj(obj)
            s = saveobj@corinet.task.generator.base.GenerationStructureBased(obj);
            if ~isempty(obj.fCombine)
                s.combine = func2str(obj.fCombine);
            end
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
            obj = corinet.task.generator.simple.PopulationSignal1(s);
            obj = reload(obj,s);
        end
    end
    
    methods
        %
        % EXECUTE functionality
        %
        function gStruct = createGenerationStructure(obj)
            gStruct = createGenerationStructure@corinet.task.generator.base.GenerationStructureBased(obj);
            if ~isempty(obj.fCombine)
                gStruct.combine = obj.fCombine;
            end
        end
        function rsult = generate(obj,in)
            % function rsult = generate(obj,in)
            %   in: cell array, one for each cell in rsult
            rsult = i_generate(createGenerationStructure(obj),in);
        end  
    end
end

function rsult = i_generate(S,in)

positions = in{1};
numPatterns = numel(positions);
temp = cell(size(positions));
for i=1:numPatterns
    numPositions = size(positions{i},1);
    if numPositions > 0
        temp{i} = S.generate(S,positions{i}(1,:));
        for j=2:numPositions
            temp{i} = S.combine(temp{i},S.generate(S,positions{i}(j,:)));
        end
    end
end
rsult = {temp};

end

