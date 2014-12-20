function disjActivationPlot1(command,S,dummy1,varargin) %#ok<INUSL>

%DISJACTIVATIONPLOT1 Plot the activation for the disj1 function

%prepare limits for the x axis
limX = [1 numel(S.Xi)];
limY = [0 numel(S.Yi)+1];

%prepare plot styles
styleX2 = 'o';
styleY1 = '*';
styleY2 = 'o';

switch command
    case 'DISJ1',
        clf;
        %%%%%%%%%%%%%%%
        subplot(2,2,4);
        plot(S.Y,styleY1);
        set(gca,'XLim',limY);
        title('Y');
    case 'DISJ2',
        %%%%%%%%%%%%%%%
        subplot(2,2,1); 
        hintonPlot(S.W); 
        title('W');
        %%%%%%%%%%%%%%%
        subplot(2,2,2); 
        plot(varargin{1},styleX2); 
        set(gca,'XLim',limX); 
        title('X');
        %%%%%%%%%%%%%%%
        subplot(2,2,3); 
        hintonPlot(S.WP);
        title('W^*W~');
        %%%%%%%%%%%%%%%
        subplot(2,2,4); 
        hold on;
        plot(S.Y,styleY2);
        pause(0.1);
        drawnow;
end

end


