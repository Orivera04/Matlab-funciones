function varargout = set(obj , varargin)
%SET

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:32:47 $

if nargin==1
   varargout{1} = i_ShowFields;
else
   for i = 1:2:length(varargin)
      prop = lower(varargin{i});
      new_value = varargin{i+1};
      
      switch prop
      case 'position'
         if ~isnumeric(new_value) | length(new_value) ~= 4
            error('xregstepinput::Set: Position vector must be a vector of length four.');
         end
         butWidth = 20;
         editWidth = 50;
         
         left_over = new_value(3)-2*butWidth-editWidth;
         
         Pos1 = [new_value(1) new_value(2) left_over new_value(4)];
         Pos2 = [new_value(1)+left_over new_value(2) butWidth new_value(4)];
         Pos3 = [new_value(1)+left_over+butWidth new_value(2) editWidth new_value(4)];
         Pos4 = [new_value(1)+left_over+butWidth+editWidth new_value(2) butWidth new_value(4)];
         
         if Pos1(3) < 1; Pos1(3) = 1; end;
         if Pos1(4) < 1; Pos1(4) = 1; end;
         if Pos2(3) < 1; Pos2(3) = 1; end;
         if Pos2(4) < 1; Pos2(4) = 1; end;
         if Pos3(3) < 1; Pos3(3) = 1; end;
         if Pos3(4) < 1; Pos3(4) = 1; end;
         if Pos4(3) < 1; Pos4(3) = 1; end;
         if Pos4(4) < 1; Pos4(4) = 1; end;
         
         set(obj.text , 'position' , Pos1);
         set(obj.leftbutton, 'position' , Pos2);
         set(obj.edit , 'position' , Pos3);
         set(obj.rightbutton , 'position' , Pos4);
         
      case 'visible'
         vec = [obj.text obj.leftbutton obj.edit obj.rightbutton];
         switch upper(new_value)
         case 'ON'
            set(vec , 'visible' , 'on');
         case 'OFF'
            set(vec , 'visible' , 'off');
         end
      case 'parent'
         if ~ishandle(new_value) | ~strcmp(lower(get(new_value , 'type')) , 'figure')
            error('xregstepinput::Set: Invalid figure handle.');
         end
         vec = [obj.text obj.leftbutton obj.edit obj.rightbutton];
         set(vec , 'parent' , new_value);
         set(obj.text , 'backgroundcolor' , get(new_value , 'color'));
      case 'userdata'
         d = get(obj.edit , 'UserData');
         d.UserData = new_value;
         set(obj.edit , 'UserData' , d);
      case 'callback'
         d = get(obj.edit , 'UserData');
         d.callback = new_value;
         set(obj.edit , 'UserData' , d);
      case 'enable'
         if ~ischar(new_value) | (~strcmp(new_value,'on') & ~strcmp(new_value,'off'))
            error('xregstepinput::Set: enable = ''on''|''off''');
         end
         set([obj.edit obj.leftbutton obj.rightbutton],'enable',new_value);
         d = get(obj.edit , 'UserData');
         d.enable = strcmp(new_value,'on');
         set(obj.edit , 'UserData' , d);
         i_EnableButtons(obj,d);
         
      case 'vec_range'
          if ~isnumeric(new_value) | length(new_value)<1
            error('xregstepinput::Set: when setting vector range, pass a vector');
          end
         d = get(obj.edit , 'UserData');
         d.range = new_value;
         d.index = floor(length(new_value)/2);
         d.currstr = num2str(d.range(d.index));
         set(obj.edit , 'string' , num2str(d.range(d.index)));
         set(obj.edit , 'UserData' , d);
         i_EnableButtons(obj,d);
      case 'range'
         if ~iscell(new_value)
            error('xregstepinput::Set: when setting range, pass through a cell array. { [new range] , [number of points]}');
         end
         rng = new_value{1};
         num = new_value{2};
         if ~isnumeric(rng) | length(rng) ~= 2 | diff(rng) <= 0
            error('xregstepinput::Set: Problem in new range vector.');
         end
         d = get(obj.edit , 'UserData');
         d.range = linspace(rng(1) , rng(end) , num);
         d.index = floor(num/2);
         d.currstr = num2str(d.range(d.index));
         set(obj.edit , 'string' , num2str(d.range(d.index)));
         set(obj.edit , 'UserData' , d);
         i_EnableButtons(obj,d);
      case 'numsteps'
         if ~isnumeric(new_value) | prod(size(new_value))~=1
            error('xregstepinput::Set: when setting number of steps');
         end
         new_value = round(new_value);
         if new_value<2
            return
         end
         num = new_value;
         d = get(obj.edit , 'UserData');
         d.range = linspace(d.range(1) , d.range(end) , num);
         
         [tmp, ind]=min(abs(d.range - str2num(d.currstr)));
         d.index = max(1,min(ind(1),num));
         set(obj.edit , 'UserData' , d);
         
         
      case 'value'
         d = get(obj.edit , 'UserData');
         if new_value < d.range(1) | new_value > d.range(end) | length(new_value) > 1
         else
            [y,i]=min(abs(d.range-new_value));
            d.index = i(end);
            d.currstr = num2str(new_value);
            set(obj.edit , 'string' , num2str(new_value));
            i_EnableButtons(obj,d);
         end
         set(obj.edit , 'UserData' , d);
      end
   end
   if nargout > 0
      varargout{1} = obj;
   elseif ~isempty(inputname(1))
      assignin('caller' , inputname(1) , obj);
   end
end

function out = i_ShowFields
out.Position = '[1x4] Position Array.';
out.Visible = '{on|off}';
out.Parent = '[1x1] Figure Handle';
out.UserData = 'Anything.';
out.Range = '{ [new range] , number of points}';

function i_EnableButtons(obj,d)
% set enable status and cdata for left and right buttons depending
% on position within range
if d.index == 1 | ~d.enable
    set(obj.leftbutton , 'enable' , 'off' , 'cdata' , d.LeftDis);
else
    set(obj.leftbutton , 'enable' , 'on' , 'cdata' , d.LeftEn);
end
if d.index == length(d.range) | ~d.enable
    set(obj.rightbutton , 'enable' , 'off' , 'cdata' , d.RightDis);
else
    set(obj.rightbutton , 'enable' , 'on' , 'cdata' , d.RightEn);
end


