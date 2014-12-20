function hintonPlot(W,ofType,equal,scale,colour)

%function hintonPlot(ofType,W,equal,scale,colour)
%  ofType: 'SIZE', 'IMAGE', or 'INTENSITY', default = 'IMAGE'
%  equal: equal aspect ratios, true or false, default = true
%  scale: scale factor, default = 1
%  colour: 1 ('r'), 2 ('g') or 3 ('b'), default = 3

if nargin < 5
    colour = 3;
end
if nargin < 4
    scale = 1;
end
if nargin < 3
    equal = true;
end
if nargin < 2
    ofType = 'IMAGE';
end

colourStr = ['r','g','b'];

switch ofType
    case 'SIZE'
        [aspectX,aspectY] = i_getAspectRatio(W,equal);
        for i=1:size(W,2)
            for j=1:size(W,1)
                boxX=aspectX*0.5*W(j,i)/(scale);
                boxY=aspectY*0.5*W(j,i)/(scale);
                fill([i-boxX,i+boxX,i+boxX,i-boxX],size(W,1)+1-[j-boxY,j-boxY,j+boxY,j+boxY],colourStr(colour));
                hold on;
            end
        end 
        if equal 
            axis equal;
        end
        axis([0.5, size(W,2)+0.5, 0.5, size(W,1)+0.5]);  
    case 'IMAGE'
        %draw as an image: strength indicated by pixel darkness
        %W is true data value (greater than 0) and is scaled to be between 0 and 255
        image(uint8(round((W/scale)*255)),'CDataMapping','scaled'),
        colormap(gray);
        map=colormap;
        map=flipud(map);
        map(:,colour)=map(:,colour)*0.0+1;
        colormap(map)
        caxis([0,255]);
        axis on;
        if(equal==1), 
            axis equal;
            axis tight;
        end
    case 'INTENSITY'
        [aspectX,aspectY] = i_getAspectRatio(W,equal);
        boxX=aspectX*0.33;
        boxY=aspectY*0.33;
        for i=1:size(W,2)
            for j=1:size(W,1)
                fill([i-boxX,i+boxX,i+boxX,i-boxX],size(W,1)+1-[j-boxY,j-boxY,j+boxY,j+boxY],ones(1,4).*round((W(j,i)./scale)*255),'FaceColor','flat');
                hold on;
            end
        end
        colormap(gray);
        map=colormap;
        map=flipud(map);
        map(1:64,colour)=map(1:64,colour)*0.0+1;
        colormap(map)
        caxis([0,255]);
        if equal 
            axis equal;
        end
        axis([0.5, size(W,2)+0.5, 0.5, size(W,1)+0.5]);
end 

hold off;
set(gca,'YTick',[]);
set(gca,'XTick',[]);

end

function [aspectX,aspectY] = i_getAspectRatio(W,equal)

if ~equal
    %calc aspect ratio - if not going to set axis equal
    plot(size(W,2)+0.5,size(W,1)-0.5,'bx');
    hold on;
    plot(0.5,-0.5,'bx');
    axis equal;
    a=axis;
    aX=size(W,2)/abs(a(2)-a(1));
    aY=size(W,1)/abs(a(4)-a(3));
    aspectX=aX/max(aX,aY);
    aspectY=aY/max(aX,aY);
    hold off;
else
    aspectX=1;
    aspectY=1;
end

end


