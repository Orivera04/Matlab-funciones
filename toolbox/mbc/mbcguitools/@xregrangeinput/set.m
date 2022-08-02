function obj = set(obj, varargin)
%% XREGRANGEINPUT/SET
%%     set(xregrangeInput, 'Property', Value)
%%     Property = {'Position', 'Name', 'Parent', 'Value'}
%%
%%     Also at this time only one parameter value pair per call
%%     can be used
%%
%%     This form of the set method return a modified form
%%     of the object
%%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.5.2.2 $  $Date: 2004/02/09 07:32:42 $

d = length(varargin)/2;
nparam = floor(d);

ud = get(obj.name,'userdata');

for arg=1:2:nparam*2-1
   parameter = varargin{arg};
   value = varargin{arg+1};
   switch upper(parameter)
      
   case 'POSITION'
      %% NOTE ideally want 140 pixels for the controls, hence put
      %% name as only 20 pixels min
      pos=value;
      if pos(3) < 80, pos(3) = 80; end;
      if pos(4) < 15, pos(4) = 15; end;
      
      if pos(3)<200
         set(obj.layout,...
            'colratios',[3,1,2,1,2,1,2],...
            'colsizes',[],...
            'gapx',1);
      elseif pos(3)<300
         set(obj.layout,...
            'colratios',[],...
            'colsizes',[-1,23,40,23,40,20,25],...
            'gapx',1);
      elseif pos(3)<350
         set(obj.layout,...
            'colratios',[],...
            'colsizes',[-1,23,50,23,50,20,25],...
            'gapx',1);
      else
         set(obj.layout,...
            'colratios',[],...
            'colsizes',[-1,23,60,23,60,20,30],...
            'gapx',5);
      end      
      
      set(obj.layout,'position',pos);      
      
   case 'CALLBACK'
      ud.callback = value;
      
   case {'VARNAME','NAME'}
      if ischar(value)
         set(obj.name,'string',value);
      end
      
   case 'VALUE'
      %% will only accept vector (can be from wrkspce)
      if isnumeric(value) & isreal(value) & length(value)>1 & prod(size(value))==length(value)
         %% vector - turn into linspace
         set(obj.edit(1),'string',num2str(min(value))); ud.min = min(value);
         set(obj.edit(2),'string',num2str(max(value))); ud.max = max(value);
         set(obj.edit(3),'string',num2str(length(value))); ud.points = length(value);
         
      else
         try
            %% try base workspace
            w = evalin('base' , 'whos');
            names = {w.name};
            ind = strmatch(value , names , 'exact');
            new_value = evalin('base' , names{ind});
            if isnumeric(new_value) & isreal(new_value) & length(new_value)>1 & prod(size(value))==length(value) 
               %% vector - turn into linspace
               set(obj.edit(1),'string',num2str(min(new_value))); ud.min = min(value);
               set(obj.edit(2),'string',num2str(max(new_value))); ud.max = max(value);
               set(obj.edit(3),'string',num2str(length(new_value))); ud.points = length(value);
            end
            
         catch  %% leave it as it was
            set(obj.edit(1),'string',ud.min);
            set(obj.edit(2),'string',ud.max);
            set(obj.edit(3),'string',ud.points);
         end
      end
      
   case 'MIN'
      if isnumeric(value)
         ud.min = value;
      end
      
   case 'MAX'
      if isnumeric(value)
         ud.max = value;
      end
      
   case {'POINTS','PTS'}
      if isnumeric(value)
         ud.points = value;
      end
      
   case 'VISIBLE'
      if ischar(value)
         switch upper(value)
         case 'OFF'
            set([obj.name; obj.edit(:); obj.text(:)],'visible','off');
            
         case 'ON'
            set([obj.name; obj.edit(:); obj.text(:)],'visible','on');
         end
      end
      
   case 'PARENT'
      if ishandle(value)
         set([obj.name; obj.edit(:); obj.text(:)],'parent',value);
      end
      
      
   case 'USERDATA'
      ud.UserData = value;
      
   case 'FONTWEIGHT'
      try
         set([obj.name; obj.text(:)],'fontweight',value);      
      end
      
   otherwise
      try
         set([obj.name; obj.edit(:); obj.text(:)],parameter,value);
      catch
         warning('Not a valid XREGRANGEINPUT/SET property');
      end
      
   end %switch
end

set(obj.name,'userdata',ud);

