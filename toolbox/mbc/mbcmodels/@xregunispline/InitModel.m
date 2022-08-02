function [m,OK]= InitModel(m,x,y,varargin);
% xregUniSpline/INITMODEL initialises unispline model for stats

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:58:07 $

[x,y]= checkdata(m,x,y);
if length(varargin)<1
	varargin={[]};
end
[m.mv3xspline,OK] = InitModel(m.mv3xspline,x,y,varargin{1},1);