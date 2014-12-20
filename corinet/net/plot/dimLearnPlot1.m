function dimLearnPlot1(command,S,nodeValues)

%DIMLEARNPLOT1 Plot the activation for the dimLearn1 function

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
    case 'DIM1',
        clf;
        %%%%%%%%%%%%%%%
        subplot(2,3,1); 
        plot(S.W',styleX1); 
        set(gca,'XLim',limX); 
        title('W');
        %%%%%%%%%%%%%%%
        subplot(2,3,2);
        plot(S.V*S.Y,styleX1);
        set(gca,'XLim',limX);
        hold on;
        X = nodeValues(S.Xi); X(X>1) = 1;
        plot(X,styleX2);
        title('X,V*Y');
        %%%%%%%%%%%%%%%
        subplot(2,3,3);
        plot(S.E,styleX2);
        set(gca,'XLim',limX);
        title('E');
        %%%%%%%%%%%%%%%
        subplot(2,3,4); 
        plot(S.V,styleX1); 
        set(gca,'XLim',limX); 
        title('V');
        %%%%%%%%%%%%%%%%
        subplot(2,3,5); 
        plot((1+(S.beta*S.Y)*(S.E'-1))',styleX2);
        set(gca,'XLim',limX);
        title('WMult');
        %%%%%%%%%%%%%%%
        subplot(2,3,6);
        bar(S.Y);
        set(gca,'XLim',limY);
        set(gca,'YLim',[0 ceil(max(S.Y))]);
        title('Y');
    case 'DIM2',
        %%%%%%%%%%%%%%%
        subplot(2,3,1); 
        hold on;
        plot(S.W',styleX2); 
        %%%%%%%%%%%%%%%
        subplot(2,3,4);
        hold on;
        plot(S.V,styleX2);
        pause(0.1);
        drawnow;
end

end


