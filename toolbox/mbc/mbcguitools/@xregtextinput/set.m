function obj = set(obj, varargin)
%% xregtextinput/SET
%%     set(xregtextinput, 'Property', Value)
%%     Property = {'numCells', 'Position', 'varName', 'Parent'}
%%
%%     Also at this time only one parameter value pair per call
%%     can be used
%%
%%     This form of the set method return a modified form
%%     of the object
%%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:34:00 $

d = length(varargin)/2;
nparam = floor(d);

for arg=1:2:nparam*2-1
   parameter = varargin{arg};
   value = varargin{arg+1};
   switch upper(parameter)
      
   case 'POSITION'
      pos=value;
      if pos(3) < 20
         pos(3) = 20;
      end
      if pos(4) < 20
         pos(4) = 20;
      end
      set(obj.hnd,'position',pos);
      
   case 'VARNAME'
      if ischar(value)
         set(obj.hnd,'string',value);
      end
      
   case 'VISIBLE'
      if ischar(value)
         switch upper(value)
         case 'OFF'
            set(obj.hnd,'visible','off');
         case 'ON'
            set(obj.hnd,'visible','on');
         end
      end
      
   case 'PARENT'
      if ishandle(value)
         set(obj.hnd,'parent',value);
      end
      
   case 'CALLBACK'
      %% no callback for xregtextinput
      
   case 'VALUE'
      %% no value for xregtextinput
      
   case 'FONTWEIGHT'
      try
         set(obj.hnd,'fontweight',value);      
      end
      
   otherwise
      try
         set(obj.hnd, parameter, value);
      catch
         warning('Not a valid xregtextinput/SET property');
      end
      
   end %switch
end


