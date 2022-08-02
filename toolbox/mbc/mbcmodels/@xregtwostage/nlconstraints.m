function g= nlconstraints(p,TS,varargin);
% TWOSTAGE/NLCONSTRAINTS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:00:03 $

Nf= length(TS.Global);
st=1;
g= cell(Nf,1);
for i=1:Nf;
   Np= numNLParams(TS.Global{i});
   if Np
      % update the nonlinear global model in TS object
      m= nlupdate(TS.Global{i},p(st:st+Np-1));
      st= st+Np;
   end
   g{i}= nlconstraints(m,varargin{:});
end

g= cat(1,g{:});
