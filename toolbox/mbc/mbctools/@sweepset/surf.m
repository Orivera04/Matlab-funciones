function varargout=surf(S1,S2,S3,NumGrid);
% SWEEPSET/SURF overloaded surface plot for sweepsets with labels and light
%   surf(S1,S2,S3,NumGrid);
% 
%  S1, S2, and S3 must have only one variable
%  NumGrid [Nx,Ny] is optional

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 08:11:40 $



if nargin<4
   NumGrid=[30 30];
elseif all(size(NumGrid)==1)
   NumGrid= [NumGrid NumGrid];
end
      
S1=SetMinMax(S1);
S2=SetMinMax(S2);
S3=SetMinMax(S3);

xi=linspace(S1.var.min,S1.var.max,NumGrid(1));
yi=linspace(S2.var.min,S2.var.max,NumGrid(2))';

[X,Y,Z]=griddata(S1.data,S2.data,S3.data,xi,yi,'linear');
h=surf(X,Y,Z,'facelighting','phong','facecolor','interp','edgecolor','none');
XLim= get(gca,'XLim');
YLim= get(gca,'YLim');
ZLim= get(gca,'ZLim');
L(1)= light('pos',[XLim(2),YLim(2),ZLim(2)],'color',[.5 .5 .5],'style','local');

L(2)= light('pos',[XLim(1),YLim(1),ZLim(2)],'color','w','style','local');
xlabel(S1.var.name);
ylabel(S2.var.name);
zlabel(S3.var.name);
if nargout>0
   varargout{1}=h;
   varargout{2}= L(:);
end
