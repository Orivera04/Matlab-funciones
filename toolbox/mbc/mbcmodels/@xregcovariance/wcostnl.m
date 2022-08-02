function  [g,geq]= wcostnl(Wp,c,varargin);
% COVMODEL/WCOSTNL nonlinear constraints for correlation models

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:46:34 $

c= update(c,Wp);
[nw,bnds2,A,b,g]= feval(c.cfunc);
geq=[];