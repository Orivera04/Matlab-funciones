function p= nlparams(TS);
%NLPARAMS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:00:05 $

st=1;
p=cell(length(TS.Global),1);
for i=1:length(TS.Global);
   Np= nlparams(TS.Global{i});
   if Np
      % update the nonlinear global model in TS object
      p{i}= nlparams(TS.Global{i});
   end
end

p= cat(1,p{:});