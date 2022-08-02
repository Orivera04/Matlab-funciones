function [varargout]= constraints(U,varargin);
% xregusermod/CONSTRAINTS
%
% [LB,UB,A,b,nlcon,optparams]= constraints(U);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 08:01:00 $

[varargout{1:6}]= feval(U.funcName,U,'constraints',varargin{:});

if all(cellfun('isempty',varargout))
   
   varargout= {[],[],[],[],0,[]};
end