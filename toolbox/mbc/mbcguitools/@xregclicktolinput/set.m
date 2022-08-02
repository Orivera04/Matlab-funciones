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


%   $Revision: 1.4.2.3 $  $Date: 2004/04/04 03:29:08 $

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
      %% change ratios if restricted length
      if pos(3)<200
         set(obj.layout,...
            'colratios',[4,4,1,2],...
            'colsizes',[],...
            'gapx',1);
      else
         set(obj.layout,...
            'colratios',[],...
            'colsizes',[-1,70,20,40],...
            'gapx',5);
      end      
      set(obj.layout,'position',pos);
      
   case 'CALLBACK'
       set(obj.clickedit,'callback',value);
      
   case {'VARNAME','NAME'}
      if ischar(value)
         set(obj.text,'string',value);
      end
      
   case {'TOLERANCE','TOL'}
      if ischar(value)
         value = str2num(value);
      end
      
      if isempty(value)
         return
      else
         set(obj.tolerance,'string',num2str(value));
         set(obj.tolerance,'userdata',num2str(value));      
      end
      
   case 'TOLERANCEENABLE'
      if strcmpi(value,'off')
         set(obj.tolerancetext,'enable','off');
         set(obj.tolerance,'enable','off',...
            'backgroundcolor',get(obj.text,'backgroundcolor'));
      else
         set(obj.tolerancetext,'enable','on');
         set(obj.tolerance,'enable','on',...
            'backgroundcolor','w');         
      end
         
   case 'VISIBLE'
      if ischar(value)
         switch upper(value)
         case 'OFF'
            set(obj.layout ,'visible','off');
         case 'ON'
            set(obj.layout,'visible','on');
         end
      end
      
   case 'PARENT'
      if ishandle(value)
         set(obj.clickedit,'parent',value);
         set([obj.text,obj.tolerancetext,obj.tolerance],'parent',value);
         set(obj.layout,'parent',value);
      end
      
   case 'USERDATA'
      ud.UserData = value;
      
   case 'FONTWEIGHT'
      try
         set([obj.text,obj.tolerancetext],'fontweight',value);      
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

