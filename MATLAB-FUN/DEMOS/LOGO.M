%LOGO Plot the MATLAB L-shaped membrane logo.

%	Mark W. Reichelt, 7-27-93
%	Copyright (c) 1984-94 by The MathWorks, Inc.

newplot;	% make sure that we open a new figure if we need it
set(gca,'Visible','off')

% Demo initialization ====================
if ~exist('GalleryGUIFlag'), figNumber=0; end;

infoStr= ...                                                     
   str2mat(' ', ...
           ' This is the MathWorks logo, found on the cover', ...
	   ' of the documentation.  It consists of an', ...
	   ' L-shaped membrane superimposed on top of', ...
	   ' a spiral of inverses.', ...
	   ' ', ...
	   ' File name: logo.m');
gallinit(figNumber,infoStr)

% Beginning of the demo ==================

p1 = get(gca,'position');

set(gca,'position',[0 0 0.78 1])
m = 10;
n = 6;
set(gca,'Xlim',[0 n],'YLim',[0 m])
a = spiral(max(m,n));
a = 1 ./ a;

%for r = 1:m
%  for c = 1:n
%    s = sprintf('%.4f',a(r,c+2));
%    text(c-.5,m-r+.5,s,'HorizontalAlignment','center','Color',[.7 .7 .7], ...
%         'FontSize',10,'FontAngle','italic');
%  end
%end

% This is faster, but a little dirty.
for r = 1:m
  s = sprintf( ...
'%.4f         %.4f         %.4f         %.4f         %.4f         %.4f         %.4f         %.4f', ...
	      a(r,1:8));
  text(n/2*0+4,m-r+.5,s,'HorizontalAlignment','center','Color',[.7 .7 .7], ...
       'FontSize',10,'FontAngle','italic');
end

axis off

axes;
p0 = get(0,'defaultaxesposition');
p = [p1(1) + (p1(1)+p1(3)*0.5 - p0(1)-p0(3)*0.5), p0(2:4)];
set(gca,'Position',p);

load logo
n = length(L(:,1));
if isstudent
   k = 1:2:n; n = length(k);
   L = L(k,k); R = R(k,k);
end
surf(L,R), colormap(M)
axis off

% End of the demo ========================
