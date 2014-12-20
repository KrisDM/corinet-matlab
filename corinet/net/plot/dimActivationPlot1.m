function dimActivationPlot1(command,S,dummy1,varargin) %#ok<INUSL>

%DIMACTIVATIONPLOT1 Plot the activation for the dim1 function

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
styleY1 = '*';
styleY2 = 'o';

switch command
    case 'DIM1',
        clf;
        %%%%%%%%%%%%%%%
        subplot(2,3,2);
        plot(S.V*S.Y,styleX1);
        set(gca,'XLim',limX);
        title('X,V*Y');
        %%%%%%%%%%%%%%%
        subplot(2,3,3);
        plot(S.E,styleX1);
        set(gca,'XLim',limX);
        title('E');
        %%%%%%%%%%%%%%%
        subplot(2,3,6);
        plot(S.Y,styleY1);
        set(gca,'XLim',limY);
        title('Y');
    case 'DIM2',
        %%%%%%%%%%%%%%%
        subplot(2,3,1); 
        plot(S.W',styleX2); 
        set(gca,'XLim',limX); 
        title('W');
        %%%%%%%%%%%%%%%
        subplot(2,3,2); 
        hold on;
        plot(varargin{1},styleX2);
        %%%%%%%%%%%%%%%
        subplot(2,3,3); 
        hold on;
        plot(S.E,styleX2);
        %%%%%%%%%%%%%%%
        subplot(2,3,4); 
        plot(S.V,styleX2); 
        set(gca,'XLim',limX); 
        title('V');
        %%%%%%%%%%%%%%%%
        subplot(2,3,5); 
        plot(S.W*S.E,styleY2); 
        set(gca,'XLim',limY); 
        title('W*E');
        %%%%%%%%%%%%%%%%
        subplot(2,3,6); 
        hold on;
        plot(S.Y,styleY2);
        pause(0.1);
        drawnow;
end

end


