function m=loadobj(m)
% LOADOBJ  Load old NNMODEL objects in
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:56:25 $

% Create 10/11/2000 

if isa(m,'xregnnet')
   % check for dodgy R12 load
   if m.param.numOutputs==0;
      m.param=fix_nnetload(m.param);
      m.param.outputConnect=m.param.outputConnect;  % force update of hint structure
   end
end
