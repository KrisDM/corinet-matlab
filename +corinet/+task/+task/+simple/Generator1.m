classdef Generator1 < corinet.task.task.base.GeneratorBased
    
    %GENERATOR1 Simple generator-based task, delegating entirely to
    %PatternGenerator
    
    methods
        %
        % CONSTRUCTOR
        %
        function obj = Generator1(taskMaker)
            obj = obj@corinet.task.task.base.GeneratorBased(taskMaker);
            for i=1:numel(taskMaker.inportNames)
                addComponentName(obj,'inport',taskMaker.inportNames{i});
            end
            for o=1:numel(taskMaker.outportNames)
                addComponentName(obj,'outport',taskMaker.outportNames{o});
            end
        end
        %
        % LOAD/SAVE functionality
        %
        function s = saveobj(obj)
            s = saveobj@corinet.task.task.base.GeneratorBased(obj);
        end
        function obj = reload(obj,s)
            obj = reload@corinet.task.task.base.GeneratorBased(obj,s);
        end
    end
    
    methods (Static = true)
        %
        % LOAD/SAVE functionality
        %
        function obj = loadobj(s)
            obj = corinet.task.task.simple.Generator1(s);
            obj = reload(obj,s);
        end
    end
    
    methods 
        %
        % EXECUTE functionality
        %
        function context = generate(obj,context)
            in = cell(1,numel(obj.inportNames));
            for i=1:numel(obj.inportNames)
                in{i} = context.(obj.inportNames{i});
            end
            rsult = generate(obj.patternGenerator,in);
            for o=1:numel(obj.outportNames)
                context.(obj.outportNames{o}) = rsult{o};
            end    
        end
    end
end

