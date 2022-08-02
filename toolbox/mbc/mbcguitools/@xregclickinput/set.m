function obj = set(obj, varargin)
%% xregconstinput/SET
%%     set(xregconstinput, 'Property', Value)
%%     Property = {'Position', 'Name', 'Parent', 'Value'}
%%
%%     Also at this time only one parameter value pair per call
%%     can be used
%%
%%     This form of the set method return a modified form
%%     of the object
%%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:31:31 $

d = length(varargin)/2;
nparam = floor(d);

ud = get(obj.text,'userdata');

for arg=1:2:nparam*2-1
   parameter = varargin{arg};
   value = varargin{arg+1};
   switch upper(parameter)
      
   case 'POSITION'
      pos=value;
      if pos(3) < 20
         pos(3) = 20;
      end
      if pos(4) < 10
         pos(4) = 10;
      end
      
      editLength = min(max(pos(3)/2,10),80);
      editPos = [pos(1)+pos(3)-editLength pos(2) editLength pos(4)];
      set(obj.clickedit,'position',editPos);
      txtLength = pos(3)-editLength;
      txtPos = pos; txtPos(3) = txtLength;
      set(obj.text,'position',txtPos);
      
   case 'CALLBACK'
      set(obj.clickedit,'callback',value);
      
   case {'VARNAME','NAME'}
      if ischar(value)
         set(obj.text,'string',value);
      end
      
      
   case 'VISIBLE'
      if ischar(value)
         switch upper(value)
         case 'OFF'
            set(obj.clickedit ,'visible','off');
            set(obj.text,'visible','off');
         case 'ON'
            set(obj.clickedit,'visible','on');
            set(obj.text,'visible','on');
         end
      end
      
   case 'PARENT'
      if ishandle(value)
         set(obj.clickedit,'parent',value);
         set(obj.text,'parent',value);
      end
      
   case 'USERDATA'
      ud.UserData = value;
      % pass userdata through to clickedit control so that
      % it can be retrieved via the callback.
      set(obj.clickedit,'userdata',value);
      
   case 'FONTWEIGHT'
      try
         set(obj.text,'fontweight',value);      
      end
      
   otherwise
      try
         set(obj.clickedit,parameter,value);
      catch
         warning('Not a valid XREGCLICKINPUT/SET property');
      end
      
   end %switch
end

set(obj.text,'userdata',ud);

