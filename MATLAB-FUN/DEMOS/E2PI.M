%E2PI	Which is greater, e^pi or pi^e?

%	Ned Gulley, 6-21-93
%	Copyright (c) 1984-94 by The MathWorks, Inc.

% Demo initialization ====================
if ~exist('SlideShowGUIFlag'), figNumber=0; end;

x=0:0.16:5;
y=0:0.16:5;
[xx,yy]=meshgrid(x,y);
zz=xx.^yy-yy.^xx;

if ssinit(figNumber),
    h=surf(x,y,zz);
    set(h,'EdgeColor',[0.7 0.7 0.7]);
    view(20,50);
    colormap(hsv);

    str= ...                                                              
    [' Press the "Start" button to see an example of visualization '  
     ' in MATLAB applied to the question:                          '  
     '                                                             '
     ' "Which is greater, e^pi or pi^e?"                           '];
    ssdisp(figNumber,str);    
    if figNumber, return; end
end

% Beginning of the demo ==================

str= ...                                                                 
    [' The question is: which is greater, e^pi or pi^e? The easy way  '  
     ' to find out is to type it directly at the MATLAB command       '  
     ' prompt. But it motivates a more interesting question. What     '  
     ' is the shape of the function z=x^y-y^x? Here is a plot of z.   '  
     '                                                                '  
     ' >> x=0:0.16:5; y=0:0.16:5;                                     '  
     ' >> [xx,yy]=meshgrid(x,y);                                      '  
     ' >> zz=xx.^yy-yy.^xx;                                           '  
     ' >> surf(x,y,zz)                                                '  
     '                                                                '];
ssdisp(figNumber,str);                                                   

title('z=x^y-y^x');
xlabel('x');
ylabel('y');
drawnow;

if sspause(figNumber), return; end;

str= ...                                                              
    [' Now it turns out that the solution of the equation x^y-y^x=0'  
     ' has a very interesting shape. Because interesting things    '  
     ' happen near e and pi, our original question is not easily   '  
     ' solved by inspection. Here is a plot of that equation shown '  
     ' in black.                                                   '  
     '                                                             '  
     ' >> hold on;                                                 '  
     ' >> [c,h]=contour(x,y,zz,[0 0],''k'');                         '  
     ' >> set(h,''LineWidth'',2);                                    '  
     ' >> hold off;                                                '  
     '                                                             '];
ssdisp(figNumber,str);                                                

% Actually, I use a method slightly different than the one above
% in order to prevent part of the contour from hiding under the
% rug of the surface plot. The code shown above will work, but not
% quite as cleanly as that below.
c=contourc(x,y,zz,[0 0]);
list1Len=c(2,1);
xContour=[c(1,2:1+list1Len) NaN c(1,3+list1Len:size(c,2))];
yContour=[c(2,2:1+list1Len) NaN c(2,3+list1Len:size(c,2))];
line(xContour,yContour,'Color','k','EraseMode','none','LineWidth',2)
drawnow

if sspause(figNumber), return; end;

str= ...                                                              
    [' Here is a plot of the integer solutions to the equation     '  
     ' x^y-y^x=0. Notice 2^4=4^2 is the ONLY integer solution      '  
     ' where x~=y.  And what is the intersection point of the two  '  
     ' curves that define where x^y=y^x?                           '  
     '                                                             '  
     ' >> h=plot([0:5 2 4],[0:5 4 2],''r.'', ...                     '  
     '           ''MarkerSize'',25,''EraseMode'',''none'');              '];
ssdisp(figNumber,str);                                                

hold on;
plot([0:5 2 4],[0:5 4 2],'r.','MarkerSize',25,'EraseMode','none');
hold off;
drawnow;

if sspause(figNumber), return; end;

str= ...                                                                               
    [' Finally, we can see that e^pi is indeed larger than pi^e                     '  
     ' (though not by much) by plotting these points on our surface.                '  
     '                                                                              '  
     ' >> e=exp(1);                                                                 '  
     ' >> e^pi                                                                      '  
     ' ans =                                                                        '  
     '            23.1407                                                           '  
     ' >> pi^e                                                                      '  
     ' ans =                                                                        '  
     '            22.4592                                                           '];
ssdisp(figNumber,str);                                                                 

hold on;
e=exp(1);
plot([e pi],[pi e],'r.','MarkerSize',25,'EraseMode','none');
plot([e pi],[pi e],'y.','MarkerSize',10,'EraseMode','none');
text(e,3.5,'(e,pi)','Color','k', ...
    'EraseMode','none', ...
    'HorizontalAlignment','left');
text(3.3,e,'(pi,e)','Color','k', ...
    'EraseMode','none', ...
    'HorizontalAlignment','left');
hold off;
drawnow;

% End of the demo ========================

