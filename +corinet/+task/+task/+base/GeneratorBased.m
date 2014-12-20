classdef GeneratorBased < corinet.task.task.base.Task
    
    %GENERATORBASED Base class for tasks built around a PatternGenerator
    
    properties (SetAccess = private, GetAccess = protected)
        patternGenerator
    end
    
    methods
        %
        % CONSTRUCTOR
        %
        function obj = GeneratorBased(taskMaker)
            obj = obj@corinet.task.task.base.Task(taskMaker);
        end
        %
        % LOAD/SAVE functionality
        %
        function s = saveobj(obj)
            s = saveobj@corinet.task.task.base.Task(obj);
            s.generatorMaker = saveobj(obj.patternGenerator);
        end
        function obj = reload(obj,s)
            obj = reload@corinet.task.task.base.Task(obj,s);
            if isfield(s,'generatorMaker')
                fHandle = str2func(sprintf('%s.loadobj',s.generatorMaker.className));
                obj.patternGenerator = fHandle(s.generatorMaker);
            end
        end
    end
    
    methods 
        %
        % BUILD functionality
        %
        function setGenerator(obj,patternGenerator)
            if ~isa(patternGenerator,'corinet.task.generator.base.PatternGenerator')
                ME = MException('Task:NotAGenerator','''%s'' is not a valid subtype of ''corinet.task.generator.base.PatternGenerator''.',...
                    class(patternGenerator));
                throw(ME);
            end
            obj.patternGenerator = patternGenerator;
        end  
        function rsult = getGenerator(obj)
            rsult = obj.patternGenerator;
        end
    end
end

