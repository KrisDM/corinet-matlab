classdef FigureInfo < handle
    
    %FIGUREINFO Customise the appearance of figures
    
    properties
        mAxisInfos = AxisInfo.empty
        mSubplotNumbers = cell(0);
        mPanelInfos = PanelInfo.empty;
    end
    properties
        mColor = [];
    end
    properties
        mName = '';
    end
    properties 
        mUnits = ''; %can be inches | centimeters | normalized | points | pixels | characters
    end
    methods
        %
        % Get and set operations
        %
        function set.mUnits(obj,value)
            corinet.plot.PlotPanel.checkAllowed({'inches','centimeters','normalized','points','pixels','characters'},value);
            obj.mUnits = value;
        end
        %
        % Funcionality
        %
        function apply(obj,hFigure) 
            if ~isempty(obj.mColor)
                set(hFigure,'Color',obj.mColor)
            end
            if ~isempty(obj.mName)
                set(hPanel,'Name',obj.mName)
            end
            if ~isempty(obj.mUnits)
                set(hPanel,'Units',obj.mUnits);
            end
        end
    end
    methods (Access = private, Static = true)
        function checkAllowed(allowedValues,actualValue)
            if ~any(ismember(allowedValues,actualValue))
                ME = MException('FigureInfo:Set',corinet.plot.FigureInfo.constructErrorMessage(allowedValues));
                throw(ME);
            end
        end    
        function s = constructErrorMessage(allowedValues)
            firstEl = sprintf('Value should be \''%s\''',allowedValues{1});
            if numel(allowedValues) > 1
                lastEl = sprintf(' or \''%s\''',allowedValues{end});
            else
                lastEl = '';
            end
            if numel(allowedValues) > 2
                midEl = sprintf(', \''%s\''',allowedValues{2:end-1});
            else
                midEl = '';
            end
            s = sprintf('%s%s%s.',firstEl,midEl,lastEl); 
        end
    end
end

