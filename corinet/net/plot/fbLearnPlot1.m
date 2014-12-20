function fbLearnPlot1(command,S,nodeValues)

%PCBCBLEARNPLOT1 Plot the activation for the pcbcbLearn1 function, or for
%the combination dimLearn2/fbLearn1

%DIMLEARNPLOT2 Plot the activation for the dimLearn2 function

%prepare limits for the x axis
limY = [0 numel(S.Yi)+1];
limFB = [1 numel(S.YFBi)];

%prepare plot styles
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
    case 'FB1'
        plotIDs = {'U1','YFB','Y','U*YFB','Pseudo E','UMult'};
        YFB = nodeValues(S.YFBi); YFB(YFB>1) = 1;
        pseudoE = S.Y./((S.U)*YFB);
    case 'FB2'
        plotIDs = {'U2'};
    otherwise
        plotIDs = {};
end

for i=1:numel(plotIDs)
    switch plotIDs{i}
        case 'U1'
            subplot(2,3,1); cla;
            plot(S.U',styleFB1);
            set(gca,'XLim',limFB);
            title('U');
        case 'U2'
            subplot(2,3,1);
            hold on;
            plot(S.U',styleFB2);
        case 'YFB' 
            subplot(2,3,2); cla;
            plot(YFB,styleFB2);
            set(gca,'XLim',limFB);
            title('YFB');
        case 'Y'
            subplot(2,3,3); cla;
            bar(S.Y);
            set(gca,'XLim',limY);
            set(gca,'YLim',[0 ceil(max(S.Y))]);
            title('Y');
        case 'UMult'
            subplot(2,3,4); cla;
            plot((1 + (pseudoE-1)*(S.beta*YFB)')',styleFB2);
            set(gca,'XLim',limFB);
            title('UMult');
        case 'U*YFB'
            subplot(2,3,5); cla;
            plot(S.U*YFB,styleY2);
            set(gca,'XLim',limY);
            title('U*YFB');
        case 'Pseudo E'
            subplot(2,3,6); cla;
            plot(pseudoE,styleY2);
            set(gca,'XLim',limY);
            title('Pseudo E');
    end
end

switch command
    case {'FB2'}
        pause(0.1);
        drawnow;
end

end


