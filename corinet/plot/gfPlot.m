function gfPlot(x,y,visual,dark,patchCol,centralDot)

if nargin < 6
    centralDot = false;
end
if nargin < 5
    patchCol = 'g';
end

numPlots = numel(x);

xLabel = unique(x);
yLabel = unique(y);

xLabelStr = cell(1,numel(xLabel));
yLabelStr = cell(1,numel(yLabel));

for i=1:numel(xLabel)
    xLabelStr{i} = sprintf('%d',xLabel(i));
end
for i=1:numel(yLabel)
    yLabelStr{i} = sprintf('%d',yLabel(i));
end

t = 0:0.01:2*pi;
hold off;
for p=1:numPlots
    r1 = visual(p)/2;
    r2 = (visual(p)-dark(p))/2;
    if (r2 < 0)
        r2 = 0;
    end
    i = find(xLabel == x(p));
    j = find(yLabel == y(p));
    plot(i + r1*cos(t),j + r1*sin(t),'k');
    hold on;
    fill(i + r2*cos(t),j + r2*sin(t),patchCol);
    if centralDot
        plot(i,j,'k.');
    end
end

axis([0 numel(xLabel)+1 0 numel(yLabel)+1]);
axis square;
box on;
set(gca,'XTick',1:numel(xLabel));
set(gca,'XTickLabel',xLabelStr);
set(gca,'YTick',1:numel(yLabel));
set(gca,'YTickLabel',yLabelStr);
