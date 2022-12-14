function moebius2(figNumber,GalleryGUIFlag)
% Moebius Strip
% Gallery initialization =================
if ~exist('GalleryGUIFlag'), figNumber=0; end;

% Create help
infoStr= ...                                            
        ['                                             '  
         ' Moebius strip generated by revolving an     '
				 ' eccentric ellipse.                          '  
         '                                             '  
         ' Based on m-File by C. Henry Edwards,        '  
         ' Dept. of Mathematics, University of Georgia.'  
         '                                             '  
         '                                             '  
         ' File name: moebius2.m                       '];
gallinit(figNumber,infoStr);

ab = [0 2*pi];
%rtr = [7 1.5 1];
rtr = [8 0.5 1];
pq = [40 40];
box = [-10 10 -10 10 -3 3];
vue = [90 50];

tube('xycrull',ab,rtr,pq,box,vue)
set(gcf','color',[.8 .8 .8]);
colormap(hot);
view(-37.5,65);



