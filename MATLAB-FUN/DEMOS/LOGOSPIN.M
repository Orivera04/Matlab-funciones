%LOGOSPIN Makes a movie that shows The MathWorks' logo spinning.

%	Ned Gulley, 6-21-93
%	Copyright (c) 1984-94 by The MathWorks, Inc.

% Demo initialization
if ~exist('MovieGUIFlag'), figNumber=0; end;

infoStr=[ ...
         ' This movie is an animation of logo for The'  
         ' MathWorks spinning around. The logo is    '  
         ' actually the primary vibration mode of a  '  
         ' flexible membrane suspended in an L-shaped'  
         ' domain.                                   '  
         '                                           '  
         ' File name: logospin.m                     '];
mvinit(figNumber,infoStr);

% The MAT-file logo contains the membrane data used for the
% front of the v4 user guide.
load logo
h=surfl(L,source);
colormap(M);
ax=[0 60 0 60 -0.5 1];
ax=[7 52 7 52 -.5 .8];
axis(ax);
axis off;
shading flat;

m=moviein(24);

for n=1:24,
  rotate(h,[0 90],15,[21 21 0]);
  h=surfl(get(h,'XData'),get(h,'YData'),get(h,'ZData'),source);
  axis(ax);
  axis off;
  shading flat;
  m(:,n)=mvframe(figNumber,24);
end;

mvstore(figNumber,m);
