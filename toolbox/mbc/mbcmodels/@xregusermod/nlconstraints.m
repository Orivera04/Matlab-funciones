function [c,ceq,gc,geq]= nlconstraints(B,U,varargin);
%XREGUSERMOD/NLCONSRAINTS nonlinear constraints evaluation for fmincon

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
% $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:01:32 $

U= update(U,B);
if nargout>2
    [c,gc]= feval(U.funcName,U,'nlconstraints',varargin{:});
else
    gc=[];
    c= feval(U.funcName,U,'nlconstraints',varargin{:});
end
ceq=[];
geq=[];