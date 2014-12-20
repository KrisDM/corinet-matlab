classdef ExpDIM1 < corinet.experiment.Experiment
    
    %ExpDIM1 Experiment with a network, a task. 
    %Values for train and test cycles need to be supplied as arrays,
    %one row for each entry and one column for each value
    
    properties
        mNetwork
        mTask
    end
    properties 
        mNumTrainIterations
        mNumTestIterations
    end
    properties (SetAccess = private)
        mTrainValues = cell(0);
        mTestValues = cell(0);
        mTestIndex = cell(0);
        mLoopLengths = cell(0);
    end
    properties 
        mTestResults = cell(0);
    end
    
    methods
        function addTrainCycle(obj,trainValues)
            obj.mTrainValues = horzcat(obj.mTrainValues,{trainValues});
        end
        function addTestCycle(obj,testValues,testIndex,loopLengths)
            obj.mTestValues = horzcat(obj.mTestValues,{testValues});
            obj.mTestIndex = horzcat(obj.mTestIndex,{testIndex});
            obj.mLoopLengths = horzcat(obj.mLoopLengths,{loopLengths});
        end
        function run(obj)
            train(obj);
            test(obj);
        end
        function train(obj)
            numTrainEpisodes = numel(obj.mTrainValues);
            for i=1:numTrainEpisodes
                i_train_episode(obj.mTrainValues,obj.mTask,obj.mNetwork,obj.mNumTrainIterations);
            end
        end
        function test(obj)
            numTestEpisodes = numel(obj.mTestValues);
            for i=1:numTestEpisodes
                i_test_episode(obj.mTestValues,obj.mTestIndex,obj.mLoopLength,...
                    obj.mTask,obj.mNetwork,obj.mNumTestIterations);
            end
        end
    end
end

function i_train_episode(trainValues,task,network,numIterations)

numTrainCycles = size(trainValues,1);

for i=1:numTrainCycles
    tVals = num2cell(trainValues(i,1));
    generate(task,tVals{:});
    reset(network);
    setInput(network,task.mValues);
    integrate(network,numIterations,0);
    learn(network);
end

end

function testResults = i_test_episode(testValues,testIndex,loopLengths,task,network,numIterations)

numTestCycles = size(testValues,1);
testResults = zeros([network.mNumNodes,loopLengths]);

S.type = '()';
for i=1:numTestCycles
    tVals = num2cell(testValues(i,1));
    generate(task,tVals(:));
    reset(network);
    setInput(network,task.mValues);
    integrate(network,numIterations,1);
    S.subs = horzcat(':',num2cell(testIndex(i,:)));
    testResults = subsasgn(testResults,S,mean(network.mYt,2));
end

end

    

