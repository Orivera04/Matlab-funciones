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


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:31:53 $

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
      
      editLength = min(max(pos(3)/2,10),60);
      editPos = [pos(1)+pos(3)-editLength pos(2) editLength pos(4)];
      set(obj.edit,'position',editPos);
      txtLength = pos(3)-editLength;
      txtPos = pos; txtPos(3) = txtLength;
      set(obj.text,'position',txtPos);
      
   case 'CALLBACK'
      ud.callback = value;
      
   case {'VARNAME','NAME'}
      if ischar(value)
         set(obj.text,'string',value);
      end
      
   case 'VALUE'
      if  isnumeric(value) & value <= ud.max & value >= ud.min...
			  &  length(value)==1 & isreal(value)         
         set(obj.edit,'string',num2str(value));
		 ud.value = value;
      elseif ischar(value)
         set(obj.edit,'string',value);
		 ud.value = (ud.max-ud.min)/2;
      end
      
   case 'MIN'
      if isnumeric(value) & value < ud.max
         ud.min = value;
      end    
      
   case 'MAX'
      if isnumeric(value) & value > ud.min
         ud.max = value;      
      end
      
   case 'VISIBLE'
      if ischar(value)
         switch upper(value)
         case 'OFF'
            set([obj.edit obj.text],'visible','off');
            
         case 'ON'
            set([obj.edit obj.text],'visible','on');
         end
      end
      
   case 'PARENT'
      if ishandle(value)
         set([obj.edit obj.text],'parent',value);
      end
      
      
   case 'USERDATA'
      ud.UserData = value;
      
   case 'CHARSTATUS'
      
      switch lower(value)
      case 'on'
         ud.CharStatus = 1;
      case 'off'
         ud.CharStatus = 0;
      end
      
   case 'FONTWEIGHT'
      try
         set(obj.text,'fontweight',value);      
      end
      
   otherwise
      try
         set([obj.edit obj.text],parameter,value);
      catch
         warning('Not a valid XREGCONSTINPUT/SET property');
      end
      
   end %switch
end

set(obj.text,'userdata',ud);

