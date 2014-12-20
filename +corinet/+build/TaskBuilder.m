classdef TaskBuilder
    
    %TASKBUILDER Class providing easy create methods for tasks
    
    methods (Static)
        function task = createTask(taskMaker)
            task = i_create(taskMaker);
            if isa(task,'corinet.task.task.base.GeneratorBased')
                %a task built around a PatternGenerator
                setGenerator(task,corinet.build.TaskBuilder.createGenerator(taskMaker.generatorMaker));
            end
            if isa(task,'corinet.task.task.base.Composite')
                for t=1:numel(taskMaker.taskMakers)
                    addTask(task,corinet.build.TaskBuilder.createTask(taskMaker.taskMakers{t}));
                end
                for c=1:numel(taskMaker.connections)
                    connect(task,taskMaker.connections{c});
                end
            end
        end
        function patternGenerator = createGenerator(generatorMaker)
            patternGenerator = i_create(generatorMaker);
        end
    end
end

function obj = i_create(maker)

constructorHandle = str2func(maker.className);
obj = constructorHandle(maker);

end

