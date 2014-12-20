function rsult = Experiment1(context)

%create networks and tasks
nNames = fieldnames(context.netMaker);
numNetworks = numel(nNames);
for n=1:numNetworks
    rsult.network.(nNames{n}) = corinet.build.NetBuilder.createNetwork(context.netMaker.(nNames{n}));
end
tNames = fieldnames(context.taskMaker);
for t=1:numel(tNames)
    rsult.task.(tNames{t}) = corinet.build.TaskBuilder.createTask(context.taskMaker.(tNames{t}));
end

%initialize
for n=1:numNetworks
    initialize(rsult.network.(nNames{n}));
end

eNames = fieldnames(context.execution);
for e=1:numel(eNames)
    execContext = context.execution.(eNames{e});
    if isfield(execContext,'repetitions')
        numRepetitions = execContext.repetitions;
    else
        numRepetitions = 1;
    end
    tNames = execContext.task;
    numTasks = numel(tNames);
    if isfield(execContext,'record') && isfield(execContext.record,'inexperiment')
        recNames = fieldnames(execContext.record.inexperiment);
        numRecords = numel(recNames);
        for c=1:numRecords
            execContext.results.inexperiment.(recNames{c}) = cell(numRepetitions,1);
        end
    else
        numRecords = 0;
    end
            
    for r=1:numRepetitions
        fprintf(1,'%s %d\n',eNames{e},r);
        for t=1:numTasks
            execContext = generate(rsult.task.(tNames{t}),execContext);
        end
        for n=1:numNetworks
            execContext = execute(rsult.network.(nNames{n}),execContext);
        end
        for c=1:numRecords
            execContext.results.inexperiment.(recNames{c}){r} = ...
                getValues(rsult.network.(nNames{n}),execContext.record.inexperiment.(recNames{c}));
        end
        for t=1:numTasks
            execContext = reset(rsult.task.(tNames{t}),execContext);
        end
    end
    context.execution.(eNames{e}) = execContext;
    
end

rsult.context = context;

end



