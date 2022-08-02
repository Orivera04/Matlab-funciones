function [s,g,jfac,G,J]= costknot(knots,bs,varargin); 
%COSTKNOT

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:38:03 $

% persistent store for factors
persistent FAC

r= lsqresiduals(knots,bs,varargin{:});

s= sum(r.^2);
if nargin<5 | isempty(varargin{3})
   FAC=[];
   % varargin{3}= s;
end

if nargout>1
   
   % numerical jacobian
   [J,FAC,G]= numjacknots('lsqresiduals',knots,bs,[],FAC,0,bs.fitparams.JPattern,bs.fitparams.ColMap,varargin{:});
   
   g= 2*r'*J;
   
   jfac= FAC;
end
   
