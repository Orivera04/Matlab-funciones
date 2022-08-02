function [x,y]=mmcurvex(a,b,c,d)
%MMCURVEX Intersections of Two Curves. (MM)
% [X,Y]=MMCURVEX(H1,H2) or [X,Y]=MMCURVEX([H1 H2]) finds the
% intersection points of the two curves on the X-Y plane identified
% by the line object handles H1 and H2.
%
% [X,Y]=MMCURVEX(X1,Y1,X2,Y2) finds the intersection points of the
% two curves described by the data pairs (X1,Y1) and (X2,Y2).
%
% X and Y are empty if no intersection exists.

% D.C. Hanselman, University of Maine, Orono, ME  04469
% 8/10/99
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

h1=[];
if nargin==1 & length(a)==2
   h1=a(1);
   h2=a(2);
elseif length(a)==1  &...
      ishandle(a)  &...
      strcmp(get(a,'type'),'line') &...
      length(b)==1 &...
      ishandle(b)  &...
      strcmp(get(b,'type'),'line')
   h1=a;
   h2=b;
elseif nargin~=4
   error('Incorrect Number or Type of Input Arguments.')
end
if ~isempty(h1)
   a=get(h1,'Xdata');
   b=get(h1,'Ydata');
   c=get(h2,'XData');
   d=get(h2,'Ydata');
end
if length(a)<2 | length(b)<2
   error('Data Must Have at Least Two Points.')
end
if length(a)~=length(b) | length(c)~=length(d)
   error('Individual Data Pairs Must Have Same Number of Points.')
end
xx=unique([a(:);c(:)]); % linearly interpolate at unique points
yy=interp1(a,b,xx)-interp1(c,d,xx);

x=mmsearch(yy,xx,0); % now search for zero crossings in difference
if isempty(x)
   x=[]; y=[];
else
   y=interp1(a,b,x);
end
