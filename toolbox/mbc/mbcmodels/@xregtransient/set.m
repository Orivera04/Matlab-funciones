function Dout = set(D, varargin);
% DYNAMIC/SET
%% fields supported 'param','simname','state0'

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:59:04 $

d = length(varargin)/2;
nparam = floor(d);

for arg=1:2:nparam*2-1
   parameter = varargin{arg};
   Value = varargin{arg+1};
   switch lower(parameter)
      
   case 'param'
      D = update(D,Value);
      
   case 'simname'
      D.simName = Value;
      
   case 'state0'
      D.state0 = Value;
      
   otherwise
      try
         D.xregusermod=set(D.xregusermod, parameter, Value);
      catch
         lasterr
         error(['DYNAMIC/SET invalid property ', parameter]);
      end
   end  
end

if nargout==1
   Dout=D;
else
   assignin('caller',inputname(1),D);
end