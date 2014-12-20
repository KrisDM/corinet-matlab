classdef NetBuilder
    
    %NETBUILDER Class providing easy create methods
    
    methods (Static)
        function network = createNetwork(netMaker)
            network = i_create(netMaker);
            if isa(network,'corinet.net.network.base.BlockBased')
                %a block-based networks needs blocks and connections
                %between blocks to be added to the network
                for i=1:numel(netMaker.blockMakers)
                    addBlock(network,corinet.build.NetBuilder.createBlock(netMaker.blockMakers{i}));
                end
                for c=1:numel(netMaker.connections)
                    connect(network,netMaker.connections{c});
                end
            end
        end
        function block = createBlock(blockMaker)
            block = i_create(blockMaker);
            if isfield(blockMaker,'activation')
                activationMaker = blockMaker.activation;
                setActivation(block,corinet.build.NetBuilder.createActivation(activationMaker));
            end
            if isfield(blockMaker,'reset')
                resetMaker = blockMaker.reset;
                setReset(block,corinet.build.NetBuilder.createReset(resetMaker));
            end
            if isfield(blockMaker,'weights')
                wNames = fieldnames(blockMaker.weights);
                for i=1:numel(wNames)
                    wStruct = blockMaker.weights.(wNames{i});
                    if isfield(wStruct,'init')
                        setWeightsInitializer(block,wNames{i},...
                            corinet.build.NetBuilder.createInitializer(wStruct.init));
                    end
                    if isfield(wStruct,'learn')
                        setLearn(block,wNames{i},...
                            corinet.build.NetBuilder.createLearn(wStruct.learn));
                    end
                end
            end
            if isfield(blockMaker,'plot') && isfield(blockMaker.plot,'activation')
                setPlot(block,'activation',corinet.build.NetBuilder.createPlot(blockMaker.plot.activation));
            end
            if isfield(blockMaker,'plot') && isfield(blockMaker.plot,'learn')
                setPlot(block,'learn',corinet.build.NetBuilder.createPlot(blockMaker.plot.learn));
            end    
        end
        function initObj = createInitializer(initMaker)
            initObj = [];
            if ischar(initMaker) %initMaker is function name
                initObj = str2func(initMaker); %convert to function handle
            elseif isstruct(initMaker) %initMaker is struct to create Initializer object
                initObj = i_create(initMaker);
            end
        end
        function actObj = createActivation(activationMaker)
            actObj = [];
            if ischar(activationMaker) %activationMaker is a function name
                actObj = str2func(activationMaker); %convert to function handle
            end
        end
        function resetObj = createReset(resetMaker)
            resetObj = [];
            if ischar(resetMaker) %resetMaker is a function name
                resetObj = str2func(resetMaker);
            end
        end
        function learnObj = createLearn(learnMaker)
            learnObj = [];
            if ischar(learnMaker) %learnMaker is function name
                learnObj = str2func(learnMaker); %convert to function handle
            end
        end
        function learnObj = createPlot(plotMaker)
            learnObj = [];
            if ischar(plotMaker) %plotMaker is function name
                learnObj = str2func(plotMaker); %convert to function handle
            end
        end
    end
end

function obj = i_create(maker)

constructorHandle = str2func(maker.className);
obj = constructorHandle(maker);

end

