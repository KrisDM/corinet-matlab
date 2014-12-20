classdef Block < handle
    
    %BLOCK Base class for block of nodes, the functional unit of networks
    
    properties (SetAccess = private)
        ID
    end
    properties (SetAccess = private)
        inportNames = {}
        outportNames = {}
        weightsNames = {}
        internalNames = {}
        paramNames = {}
    end
    properties
        params
    end
    properties (SetAccess = private,GetAccess = private, Hidden)
        activation
        reset = []
    end
    properties (SetAccess = private,GetAccess = private, Hidden)
        weightsCombinationNames = {}
        weightsToInitializer
        weightsToLearn
    end
    properties (SetAccess = private,GetAccess = private, Hidden)
        plotNameToPlot
    end
    
    methods
        %
        % CONSTRUCTOR
        %
        function obj = Block(blockMaker)
            if ~isa(blockMaker.ID,'char')
                ME = MException('Block:ID','Block ID should be of type ''char''');
                throw(ME);
            end
            obj.ID = blockMaker.ID;
            obj.params = blockMaker.params;
            obj.paramNames = fieldnames(blockMaker.params)';
            obj.weightsToInitializer = containers.Map;
            obj.weightsToLearn = containers.Map;
            obj.plotNameToPlot = containers.Map;
        end
        %
        % LOAD/SAVE functionality
        %
        function s = saveobj(obj)
            s.ID = obj.ID;
            s.className = class(obj);
            s.params = obj.params;
            if hasActivation(obj)
                s.activation = saveobj(obj.activation);
            end
            wNames = keys(obj.weightsToInitializer);
            for i=1:numel(wNames)
                s.weights.(wNames{i}).init = saveobj(obj.weightsToInitializer(wNames{i}));
            end
            lNames = keys(obj.weightsToLearn);
            for i=1:numel(lNames)
                s.weights.(lNames{i}).learn = saveobj(obj.weightsToLearn(lNames{i}));
            end
            if hasReset(obj)
                s.reset = saveobj(obj.reset);
            end
            pNames = keys(obj.plotNameToPlot);
            for p=1:numel(pNames)
                s.plot.(pNames{p}) = saveobj(obj.plotNameToPlot(pNames{p}));
            end
        end
        function obj = reload(obj,s)
            if isfield(s,'activation')
                activationMaker = s.activation;
                if isa(activationMaker,'function_handle') %activationMaker is a function handle
                    setActivation(obj,activationMaker);
                end
            end
            if isfield(s,'reset')
                resetMaker = s.reset;
                if isa(resetMaker,'function_handle')
                    setReset(obj,resetMaker);
                end
            end     
            if isfield(s,'weights')
                wNames = fieldnames(s.weights);
                for i=1:numel(wNames)
                    if isfield(s.weights.(wNames{i}),'init')
                        initMaker = s.weights.(wNames{i}).init;
                        if isa(initMaker,'function_handle') %initMaker is function handle
                            setWeightsInitializer(obj,wNames{i},initMaker);
                        elseif isstruct(initMaker) %initMaker is struct for Initializer object
                            fHandle = str2func(sprintf('%s.loadobj',initMaker.className));
                            setWeightsInitializer(obj,wNames{i},fHandle(initMaker));
                        end   
                    end
                    if isfield(s.weights.(wNames{i}),'learn')
                        learnMaker = s.weights.(wNames{i}).learn;
                        if isa(learnMaker,'function_handle') %learnMaker is function handle
                            setLearn(obj,wNames{i},learnMaker);
                        end
                    end 
                end
            end
            if isfield(s,'plot')
                pNames = fieldnames(s.plot);
                for p=1:numel(pNames)
                    plotMaker = s.plot.(pNames{p});
                    if isa(plotMaker,'function_handle') %plotMaker is function handle
                        setPlot(obj,pNames{p},plotMaker);
                    end
                end
            end       
        end
    end
    
    methods 
        %
        % BUILD functionality
        %
        function setWeightsInitializer(obj,weightsName,initializer)
            i_checkName(horzcat(obj.weightsNames,obj.weightsCombinationNames),...
                'weights or weights combination',weightsName);
            obj.weightsToInitializer(weightsName) = initializer;
        end
        function rsult = hasWeightsInitializer(obj,weightsName)
            rsult = isKey(obj.weightsToInitializer,weightsName);
        end
        function rsult = getWeightsInitializer(obj,weightsName)
            i_checkName(horzcat(obj.weightsNames,obj.weightsCombinationNames),...
                'weights or weights combination',weightsName);
            rsult = obj.weightsToInitializer(weightsName);
        end
        function setLearn(obj,weightsName,learn)
            i_checkName(horzcat(obj.weightsNames,obj.weightsCombinationNames),...
                'weights or weights combination',weightsName);
            obj.weightsToLearn(weightsName) = learn;
        end
        function rsult = hasLearn(obj,weightsName)
            rsult = isKey(obj.weightsToLearn,weightsName);
        end
        function rsult = getLearn(obj,weightsName)
            i_checkName(horzcat(obj.weightsNames,obj.weightsCombinationNames),...
                'weights or weights combination',weightsName);
            rsult = obj.weightsToLearn(weightsName);
        end   
        function rsult = getLearnNames(obj)
            rsult = keys(obj.weightsToLearn);
        end
        function setActivation(obj,act)
            obj.activation = act;
        end
        function rsult = hasActivation(obj)
            rsult = ~isempty(obj.activation);
        end
        function rsult = getActivation(obj)
            rsult = obj.activation;
        end
        function setReset(obj,res)
            obj.reset = res;
        end
        function rsult = hasReset(obj)
            rsult = ~isempty(obj.reset);
        end
        function rsult = getReset(obj)
            rsult = obj.reset;
        end
        function setPlot(obj,pName,pl)
            obj.plotNameToPlot(pName) = pl;
        end
        function rsult = hasPlot(obj,pName)
            rsult = isKey(obj.plotNameToPlot,pName);
        end
        function rsult = getPlot(obj,pName)
            rsult = obj.plotNameToPlot(pName);
        end
    end
    
    methods (Access = protected, Hidden = true)
        %
        % HELPER functionality
        %
        function addComponentName(obj,compType,compName)
            i_checkDuplicate(horzcat(obj.inportNames,obj.outportNames,obj.weightsNames,...
                obj.internalNames,obj.weightsCombinationNames,obj.paramNames),compName);
            switch compType
                case 'inport'
                    obj.inportNames{end+1} = compName;
                case 'outport'
                    obj.outportNames{end+1} = compName;
                case 'weights'
                    obj.weightsNames{end+1} = compName;
                case 'internal'
                    obj.internalNames{end+1} = compName;
                case 'weightsCombination'
                    obj.weightsCombinationNames{end+1} = compName;
            end
        end
    end
end

function i_checkDuplicate(compSet,compName)

if any(ismember(compSet,compName))
    ME = MException('Block:ComponentAlreadyIn','Duplicate component name ''%s''.',compName);
    throw(ME);
end

end

function i_checkName(compSet,compType,compName)

if ~ismember(compSet,compName)
    ME = MException('Block:UnknownName','Unknown %s name ''%s''.',compType,compName);
    throw(ME);
end

end

