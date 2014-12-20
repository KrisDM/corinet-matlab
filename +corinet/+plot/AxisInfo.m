classdef AxisInfo < handle
    
    %AXISINFO Customise the appearance of axes
    
    properties
        mTitle = '';
        mXLabel = '';
        mYLabel = '';
        mZLabel = '';
        mExtraProperties = {}; % can be one or more from tight | fill | ij | xy | equal | image | square
        mBox = ''; %can be on | off
        mHold = ''; %can be on | off
    end
    properties
        mXLim = []; %2-element vector [low,high]
        mYLim = []; %2-element vector [low,high]
        mZLim = []; %2-element vector [low,high]
        mCLim = []; %2-element vector [low,high]
    end
    properties
        mXDir = ''; %can be {normal} | reverse
        mYDir = ''; %can be {normal} | reverse
        mZDir = ''; %can be {normal} | reverse
    end
    properties
        mXGrid = ''; %can be {on} | off
        mYGrid = ''; %can be {on} | off 
        mZGrid = ''; %can be {on} | off
    end
    properties
        mXTick = NaN; %must be NaN (to be ignored) or a vector of tick values (may be empty)
        mYTick = NaN; %must be NaN (to be ignored) or a vector of tick values (may be empty)
        mZTick = NaN; %must be NaN (to be ignored) or a vector of tick values (may be empty)
        mXTickLabel = ''; %must be empty string (to be ignored) or a cell matrix of tick labels (may be empty)
        mYTickLabel = ''; %must be empty string (to be ignored) or a cell matrix of tick labels (may be empty)
        mZTickLabel = ''; %must be empty string (to be ignored) or a cell matrix of tick labels (may be empty)
    end
    properties 
        mUnits = ''; %can be inches | centimeters | normalized | points | pixels | characters
        mPosition = []; %4-element vector [left bottom width height]
        mOuterPosition = []; %4-element vector [left bottom width height]
    end
    properties
        mLegendHandles = [];
        mLegendStrings = {};
        mLegendBox = ''; %Can be mBoxoff | mBoxon
        %North | South | East | West | NorthEast | NorthWest | 
        %SouthEast | SouthWest | NorthOutside | SouthOutside | 
        %EastOutside | WestOutside | NorthEastOutside | NorthWestOutside |
        %SouthEastOutside | SouthWestOutside | Best | BestOutside
        mLegendLocation = '';      
        mLegendOrientation = ''; %Can be {vertical} | horizontal
    end
    methods
        %
        % Get and set operations
        %
        function set.mBox(obj,value)
            corinet.plot.AxisInfo.checkAllowed({'on','off'},value);
            obj.mBox = value;
        end
        function set.mHold(obj,value)
            corinet.plot.AxisInfo.checkAllowed({'on','off'},value);
            obj.mHold = value;
        end
        function set.mExtraProperties(obj,value)
            if numel(value) ~= numel(intersect({'tight','fill','ij','xy','equal','image','square'},value))
                ME = MException('AxisInfo:mExtraProperties',...
                    'Value should be a cell array consisting of one or more of ''tight'',''fill'',''ij'',''xy'',''equal'',''image'',''square''');
                throw(ME);
            else
                obj.mExtraProperties = value;
            end
        end
        function set.mXDir(obj,value)
            corinet.plot.AxisInfo.checkAllowed({'normal','reverse'},value);
            obj.mXDir = value;
        end
        function set.mYDir(obj,value)
            corinet.plot.AxisInfo.checkAllowed({'normal','reverse'},value);
            obj.mYDir = value;
        end
        function set.mZDir(obj,value)
            corinet.plot.AxisInfo.checkAllowed({'normal','reverse'},value);
            obj.mZDir = value;
        end
        function set.mXGrid(obj,value)
            corinet.plot.AxisInfo.checkAllowed({'on','off'},value);
            obj.mXGrid = value;
        end
        function set.mYGrid(obj,value)
            corinet.plot.AxisInfo.checkAllowed({'on','off'},value);
            obj.mYGrid = value;
        end
        function set.mZGrid(obj,value)
            corinet.plot.AxisInfo.checkAllowed({'on','off'},value);
            obj.mZGrid = value;
        end
        function set.mUnits(obj,value)
            corinet.plot.AxisInfo.checkAllowed({'inches','centimeters','normalized','points','pixels','characters'},value);
            obj.mUnits = value;
        end
        function set.mLegendBox(obj,value)
            corinet.plot.AxisInfo.checkAllowed({'mBoxon','mBoxoff'},value);
            obj.mLegendBox = value;
        end
        function set.mLegendLocation(obj,value)
            corinet.plot.AxisInfo.checkAllowed({'North','South','East','West','NorthEast','NorthWest',... 
                              'SouthEast','SouthWest','NorthOutside','SouthOutside',...
                              'EastOutside','WestOutside','NorthEastOutside','NorthWestOutside',...
                              'SouthEastOutside','SouthWestOutside','Best','BestOutside'},value);
            obj.mLegendLocation = value;
        end
        function set.mLegendOrientation(obj,value)
            corinet.plot.AxisInfo.checkAllowed({'horizontal','vertical'},value);
            obj.mLegendOrientation = value;
        end
        %
        % Funcionality
        %
        function apply(obj,ax)
            if nargin == 2
                ax = gca;
            end   
            if ~isempty(obj.mTitle)
                title(ax,obj.mTitle);
            end
            if ~isempty(obj.mXLabel)
                xlabel(ax,obj.mXLabel);
            end
            if ~isempty(obj.mYLabel)
                ylabel(ax,obj.mYLabel);
            end
            if ~isempty(obj.mZLabel)
                zlabel(ax,obj.mZLabel);
            end
            for i=1:numel(obj.mExtraProperties)
                axis(ax,obj.mExtraProperties{i});
            end
            if ~isempty(obj.mBox)
                set(ax,'Box',obj.mBox);
            end
            if ~isempty(obj.mHold)
                hold(ax,obj.mHold);
            end
            if ~isempty(obj.mXLim)
                set(ax,'XLim',obj.mXLim);
            end
            if ~isempty(obj.mYLim)
                set(ax,'YLim',obj.mYLim);
            end
            if ~isempty(obj.mZLim)
                set(ax,'ZLim',obj.mZLim);
            end
            if ~isempty(obj.mCLim)
                set(ax,'CLim',obj.mCLim);
            end
            if ~isempty(obj.mXDir)
                set(ax,'XDir',obj.mXDir);
            end
            if ~isempty(obj.mYDir)
                set(ax,'YDir',obj.mYDir);
            end
            if ~isempty(obj.mZDir)
                set(ax,'ZDir',obj.mZDir);
            end
            if ~isnan(obj.mXTick)
                set(ax,'XTick',obj.mXTick);
            end
            if ~isnan(obj.mYTick)
                set(ax,'YTick',obj.mYTick);
            end
            if ~isnan(obj.mZTick)
                set(ax,'ZTick',obj.mZTick);
            end
            if iscell(obj.mXTickLabel)
                set(ax,'XTickLabel',obj.mXTickLabel);
            end
            if iscell(obj.mYTickLabel)
                set(ax,'YTickLabel',obj.mYTickLabel);
            end
            if iscell(obj.mZTickLabel)
                set(ax,'ZTickLabel',obj.mZTickLabel);
            end
            if ~isempty(obj.mUnits)
                set(ax,'Units',obj.mUnits);
            end
            if ~isempty(obj.mPosition)
                set(ax,'Position',obj.mPosition);
            end
            if ~isempty(obj.mOuterPosition)
                set(ax,'OuterPosition',obj.mOuterPosition);
            end
            if ~isempty(obj.mLegendHandles)
                legend(ax,obj.mLegendHandles,obj.mLegendStrings);
            end
            if ~isempty(obj.mLegendBox)
                legend(ax,obj.mLegendBox);
            end
            if ~isempty(obj.mLegendLocation)
                legend(ax,'Location',obj.mLegendLocation);
            end
            if ~isempty(obj.mLegendOrientation)
                legend(ax,'Orientation',obj.mLegendOrientation);
            end
        end
    end
    methods (Access = private, Static = true)
        function checkAllowed(allowedValues,actualValue)
            if ~any(ismember(allowedValues,actualValue))
                ME = MException('AxisInfo:Set',corinet.plot.AxisInfo.constructErrorMessage(allowedValues));
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