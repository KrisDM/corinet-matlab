function pcbcbLearnPlot1(command,S,nodeValues)

%PCBCBLEARNPLOT1 Plot the activation for the pcbcbLearn1 function, or for
%the combination dimLearn2/fbLearn1

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
    styleFB1 = ':';
    styleFB2 = '-';
else
    limFB = limFB + [-1 1];
    styleFB1 = '*';
    styleFB2 = 'o';
end

switch command
    case 'DIM1'
        plotIDs = {'W1','V1','X,V*Y','Y','E','WMult,VMult'};
    case 'DIM2'
        plotIDs = {'W2','V2',};
    case 'FB1'
        plotIDs = {'U1','YFB','Pseudo E'};
        YFB = nodeValues(S.YFBi); YFB(YFB>1) = 1;
        pseudoE = S.Y./((S.U)*YFB);
    case 'FB2'
        plotIDs = {'U2'};
    case 'PCBC1'
        plotIDs = {'W1','V1','U1','X,V*Y','Y','E','WMult,VMult','YFB','Pseudo E'};
        YFB = nodeValues(S.YFBi); YFB(YFB>1) = 1;
        pseudoE = S.Y./((S.U)*YFB);
    case 'PCBC2'
        plotIDs = {'W2','V2','U2'};    
end

for i=1:numel(plotIDs)
    switch plotIDs{i}
        case 'W1'
            subplot(3,3,1); cla;
            plot(S.W',styleX1); 
            set(gca,'XLim',limX); 
            title('W');
        case 'V1'
            subplot(3,3,4); cla;
            plot(S.V,styleX1); 
            set(gca,'XLim',limX); 
            title('V');
        case 'U1'
            subplot(3,3,7); cla;
            plot(S.U',styleFB1);
            set(gca,'XLim',limFB);
            title('U');
        case 'W2'
            subplot(3,3,1);
            hold on;
            plot(S.W',styleX2);
        case 'V2'
            subplot(3,3,4);
            hold on;
            plot(S.V,styleX2);
        case 'U2'
            subplot(3,3,7);
            hold on;
            plot(S.U',styleFB2);
        case 'X,V*Y'
            subplot(3,3,2); cla;
            plot(S.V*S.Y,styleX1);
            set(gca,'XLim',limX);
            hold on;
            X = nodeValues(S.Xi); X(X>1) = 1;
            plot(X,styleX2);
            title('X,V*Y');
        case 'E'
            subplot(3,3,3); cla;
            plot(S.E,styleX2);
            set(gca,'XLim',limX);
            title('E');
        case 'WMult,VMult'
            subplot(3,3,5); cla;
            YE = (S.beta*S.Y)*(S.E'-1);
            plot((1+YE)',styleX2);
            set(gca,'XLim',limX);
            hold on;
            plot(1+bsxfun(@plus,YE',S.beta*(S.Y'>1)),styleX1);
            title('WMult,VMult'); 
        case 'Y'
            subplot(3,3,6); cla;
            plot(S.Y,styleY2);
            set(gca,'XLim',limY);
            title('Y');
        case 'YFB' 
            subplot(3,3,8); cla;
            plot(YFB,styleFB2);
            set(gca,'XLim',limFB);
            title('YFB');
        case 'Pseudo E'
            subplot(3,3,9); cla; 
            plot(pseudoE,styleY2);
            set(gca,'XLim',limY);
            title('Pseudo E');
    end
end

switch command
    case {'DIM2','FB2','PCBC2'}
        pause(0.1);
        drawnow;
end

end


