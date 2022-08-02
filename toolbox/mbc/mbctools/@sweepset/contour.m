function varargout=contour(S1,S2,S3);
% SWEEPSET/CONTOUR overloaded contour plot for sweepsets with labels
%   varargout=contour(S1,S2,S3)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 08:06:07 $



xi=linspace(S1.var.min,S1.var.max,30);
yi=linspace(S2.var.min,S2.var.max,30)';

[X,Y,Z]=griddata(S1.data,S2.data,S3.data,xi,yi);
c=contour(X,Y,Z);
clabel(c)
xlabel(S1.var.name);
ylabel(S2.var.name);
title(['Contour Plot for ',S3.var.name])
grid
if nargout>0
   varargout{1}=h;
end
