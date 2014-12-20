classdef PanelInfo < handle
    
    %PANELINFO Customise the appearance of uipanels
    
    properties
        mAxisInfos = AxisInfo.empty
        mSubplotNumbers = cell(0);
    end
    properties
        mBackgroundColor = [];
        mForgroundColor = [];
    end
    properties
        mBorderType = ''; %can be none | etchedin | etchedout | beveledin | beveledout | line
        mBorderWidth = []; %integer value
    end
    properties
        mTitle = ''; 
        mTitlePosition = ''; %can be lefttop | centertop | righttop | leftbottom | centerbottom | rightbottom
    end
    properties 
        mUnits = ''; %can be inches | centimeters | normalized | points | pixels | characters
        mPosition = []; %4-element vector [left bottom width height]
    end
    methods
        %
        % Get and set operations
        %
        function set.mBorderType(obj,value)
            corinet.plot.PlotPanel.checkAllowed({'none','etchedin','etchedout','beveledin','beveledout','line'},value);
            obj.mBorderType = value;
        end
        function set.mTitlePosition(obj,value)
            corinet.plot.PlotPanel.checkAllowed({'lefttop','centertop','righttop','leftbottom','centerbottom','rightbottom'},value);
            obj.mTitlePosition = value;
        end
        function set.mUnits(obj,value)
            corinet.plot.PlotPanel.checkAllowed({'inches','centimeters','normalized','points','pixels','characters'},value);
            obj.mUnits = value;
        end
        %
        % Funcionality
        %
        function apply(obj,hPanel) 
            if ~isempty(obj.mBackgroundColor)
                set(hPanel,'BackgroundColor',obj.mBackgroundColor)
            end
            if ~isempty(obj.mForgroundColor)
                set(hPanel,'ForgroundColor',obj.mForgroundColor)
            end
            if ~isempty(obj.mTitle)
                set(hPanel,'Title',obj.mTitle)
            end
            if ~isempty(obj.mTitlePosition)
                set(hPanel,'TitlePosition',obj.mTitlePosition);
            end
            if ~isempty(obj.mBorderType)
                set(hPanel,'BorderType',obj.mBorderType);
            end
            if ~isempty(obj.mBorderWidth)
                set(hPanel,'BorderType',obj.mBorderType);
            end
            if ~isempty(obj.mUnits)
                set(hPanel,'Units',obj.mUnits);
            end
            if ~isempty(obj.mPosition)
                set(hPanel,'Position',obj.mPosition);
            end
        end
    end
    methods (Access = private, Static = true)
        function checkAllowed(allowedValues,actualValue)
            if ~any(ismember(allowedValues,actualValue))
                ME = MException('PanelInfo:Set',corinet.plot.PanelInfo.constructErrorMessage(allowedValues));
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

