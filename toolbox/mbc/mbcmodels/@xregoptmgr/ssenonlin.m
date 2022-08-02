function [cost,g]= ssenonlin(B,F,c0,m,x,y,varargin)
%SSENONLIN

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:57:02 $

if nargout==1
	res= feval(F.costFunc,B,m,x,y,varargin{:});
else
	[res,J]= feval(F.costFunc,B,m,x,y,varargin{:});
	
   g= -2*res'*J;
end	

cost = sum(res.*res);