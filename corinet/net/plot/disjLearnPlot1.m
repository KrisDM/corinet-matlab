function disjLearnPlot1(command,S,dummy1,varargin) %#ok<INUSL>

%DISJLEARNPLOT1 Plot the activation for the disjLearn1 function

%prepare limits for the x axis
limX = [1 numel(S.Xi)];
limY = [0 numel(S.Yi)+1];

%prepare plot styles
if diff(limX) > 6
    styleX1 = ':';
    styleX2 = '-';
else
    limX = limX + [-1 1];
    styleX1 = '*';
    styleX2 = 'o';
end

switch command
    case 'DISJ1',
        clf;
        %%%%%%%%%%%%%%%
        subplot(2,3,1); 
        hintonPlot(S.W); 
        title('W');
        %%%%%%%%%%%%%%%
        subplot(2,3,2);
        hintonPlot((1 + (S.gamma*S.Y)*varargin{1}'));
        title('WMult');
        %%%%%%%%%%%%%%%
        subplot(2,3,3);
        bar(varargin{1});
        set(gca,'XLim',limX);
        set(gca,'YLim',[0 1]);
        title('X');
        %%%%%%%%%%%%%%%%
        subplot(2,3,5); 
        bar3((1 + (S.gamma*S.Y)*varargin{1}')');
        title('WMult');
        %%%%%%%%%%%%%%%
        subplot(2,3,6);
        bar(S.Y);
        set(gca,'XLim',limY);
        set(gca,'YLim',[0 ceil(max(S.Y))]);
        title('Y');
    case 'DISJ2',
        %%%%%%%%%%%%%%%
        subplot(2,3,4); 
        hintonPlot(S.W); 
        title('W'''); 
        pause(0.1);
        drawnow;
end

end


