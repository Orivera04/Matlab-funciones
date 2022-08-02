function bs = localbspline(knots)
%LOCALBSPLINE Local b-spline model constructor
%
%  M = LOCALBSPLINE consructs a new locl b-spline model.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.4 $  $Date: 2004/02/09 07:38:17 $

if nargin==0
   ord = 3;
   knots =1;
end

bs.version = 1;
bs.fitparams = struct('randstart',2,...
   'jfac',[]);

m = xreg3xspline('nfactors',1);
set(m,'numknots',knots);

bs = class(bs,'localbspline',localmod,m);

n = size(bs,1);
bs = AddFeat(bs,zeros(n,1),1:n);
