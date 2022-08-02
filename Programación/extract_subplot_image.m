% function extract_subplot_image(hh,nimage)
% Load any "fig" file that has images.
% extract_subplot takes arguments hh=gca (graphic current axes) and nimage;
%   the image number you want to appear on the extracted image.
% Click on the image to select the "axes"
% Execute:    hh=gca
% Execute:    extract_subplot_image(hh,23) where '23' is the image number
%    you want define.
% Note: "figure(nimage+100)" is to avoid conflict. If nimage=1, output of
%    this function will over-write current figure 1.
% This version has option to also extract a line object from the original
%    "fig" subplot and to add a new line.
% Original Jun 16, 2006 by cclayton@ucla
function extract_subplot_image(hh,nimage)
w=findobj(hh,'Type','image');   % Finds the image in gca
ww=get(w,'cdata');              % Extract image
figure(nimage+100)
set(gcf,'Units','normalized')
imagesc(ww)
myText=sprintf('Shot %i',nimage);
disp(myText)
xt=500; % Alternatively, xt = 0.05 * size(ww,2); yt=0.1*size(ww,1).
yt=75;
text(xt,yt,myText,'color','w','FontSize',18)  % Adjust x,y for annotation.
u=findobj(hh,'Type','line');    % Finds the handle to a line from original fig file.
if isempty(u)
    disp('No line in this subplot')
else
    xd=get(u,'XData');      % 2D x-coordinates for the endpoints of the line
    pause(0.03)
    xxd=[NaN NaN];
    xxd(1,1)=xd{1}(1);
    xxd(1,2)=xd{1}(2);
    pause(0.03)
    yd=get(u,'YData');      % 2D y-coordinates for the endpoints of the line
    pause(0.03)
    yyd=[NaN NaN];
    yyd(1,1)=yd{1}(1);
    yyd(1,2)=yd{1}(2);
    pause(0.03)
    hold on
    line(xxd,yyd,'Color','k','LineStyle',':','LineWidth',3)
end
line([760 760],yyd,'Color','r','LineStyle',':','LineWidth',3) % Add a line vertical line at x=760.
pause(0.3)
set(gcf,'Position',[0.0180 0.4778 0.6125 0.4145])
pause(0.3)
axis image
set(gcf,'color','w')

