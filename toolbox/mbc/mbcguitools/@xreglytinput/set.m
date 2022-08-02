function obj = set(obj, varargin)
%% xregtextinput/SET
%%     set(xreglytinput, 'Property', Value)
%%     Property = {'POSITION', 'POSITION', 'VISIBLE', 'PARENT'}
%%
%%     Also at this time only one parameter value pair per call
%%     can be used
%%
%%     This form of the set method return a modified form
%%     of the object
%%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:32:17 $

d = length(varargin)/2;
nparam = floor(d);

for arg=1:2:nparam*2-1
   parameter = varargin{arg};
   value = varargin{arg+1};
   try
      set(obj.lyt, parameter, value);
   catch
      warning('Not a valid xregtextinput/SET property');
   end
end
