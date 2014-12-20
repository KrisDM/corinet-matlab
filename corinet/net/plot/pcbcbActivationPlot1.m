function pcbcbActivationPlot1(command,S,nodeValues,varargin)

%PCBCACTIVATIONPLOT1 Plot the activation for the pcbcb1 function

%prepare limits for the x axis
limX = [1 numel(S.Xi)];
limY = [0 numel(S.Yi)+1];
limFB = [1 numel(S.YFBi)];

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
if diff(limFB) > 6
    styleFB2 = '-';
else
    limFB = limFB + [-1 1];
    styleFB2 = 'o';
end
    

switch command
    case 'PCBC1',
        clf;
        %%%%%%%%%%%%%%%
        subplot(3,3,2);
        plot(S.V*S.Y,styleX1);
        set(gca,'XLim',limX);
        title('X,V*Y');
        %%%%%%%%%%%%%%%
        subplot(3,3,3);
        plot(S.E,styleX1);
        set(gca,'XLim',limX);
        title('E');
        %%%%%%%%%%%%%%%
        subplot(3,3,6);
        plot(S.Y,styleY1);
        set(gca,'XLim',limY);
        title('Y');
    case 'PCBC2',
        %%%%%%%%%%%%%%%
        subplot(3,3,1); 
        plot(S.W',styleX2); 
        set(gca,'XLim',limX); 
        title('W');
        %%%%%%%%%%%%%%%
        subplot(3,3,2);
        hold on;
        plot(varargin{1},styleX2);
        %%%%%%%%%%%%%%%
        subplot(3,3,3); 
        hold on;
        plot(S.E,styleX2);
        %%%%%%%%%%%%%%%
        subplot(3,3,4); 
        plot(S.V,styleX2); 
        set(gca,'XLim',limX); 
        title('V');
        %%%%%%%%%%%%%%%%
        subplot(3,3,5); 
        plot(S.W*S.E,styleY1); 
        set(gca,'XLim',limY); 
        hold on;
        plot((S.W*S.E).*varargin{2},styleY2);
        title('W*E,(W*E)*FB');
        %%%%%%%%%%%%%%%%
        subplot(3,3,6); 
        hold on;
        plot(S.Y,styleY2);
        %%%%%%%%%%%%%%%%
        subplot(3,3,7);
        plot(S.U',styleFB2);
        set(gca,'XLim',limFB);
        title('U');
        %%%%%%%%%%%%%%%%%
        subplot(3,3,8);
        YFB = nodeValues(S.YFBi); YFB(YFB>1) = 1;
        plot(YFB,styleFB2);
        set(gca,'XLim',limFB);
        title('YFB');
        %%%%%%%%%%%%%%%%%
        subplot(3,3,9);
        plot(varargin{2},styleY2);
        set(gca,'XLim',limY);
        title('FB');
        pause(0.1);
        drawnow;
end

end


