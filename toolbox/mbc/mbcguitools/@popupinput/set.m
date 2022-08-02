function varargout = set(obj , varargin)
%SET

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:20:21 $

if nargin==1
   varargout{1} = i_ShowFields;
else
   for i = 1:2:length(varargin)
      property = lower(varargin{i});
      new_value = varargin{i+1};
      
      switch property
      case 'position'
         if ~isnumeric(new_value) | length(new_value) ~= 4
            error('PopupInput::Set: Position vector must be a vector of length four.');
         end
         d = get(obj.popup , 'UserData');
         s = d.split; s2 = 1-s;
         Pos1 = [new_value(1) new_value(2) s*new_value(3) new_value(4)];
         Pos2 = [new_value(1)+s*new_value(3) new_value(2) s2*new_value(3) new_value(4)];
         
         if Pos1(3) < 1; Pos1(3) = 1; end;
         if Pos1(4) < 1; Pos1(4) = 1; end;
         if Pos2(3) < 1; Pos2(3) = 1; end;
         if Pos2(4) < 1; Pos2(4) = 1; end;
         
         set(obj.text , 'position' , Pos1);
         set(obj.popup , 'position' , Pos2);
      case 'visible'
         switch upper(new_value)
         case 'ON'
            set([obj.text obj.popup] , 'visible' , 'on');
         case 'OFF'
            set([obj.text obj.popup] , 'visible' , 'off');
         end
      case 'parent'
         if ~ishandle(new_value) | ~strcmp(lower(get(new_value , 'type')) , 'figure')
            error('PopupInput::Set: Invalid figure handle.');
         end
         set([obj.text obj.popup] , 'parent' , new_value);
         set(obj.text , 'backgroundcolor' , get(new_value , 'color'));
     case 'split'
         if ~isnumeric(new_value) | length(new_value) ~= 1 | new_value<0 | new_value>1
            error('VectorInput::Set: Split must be a constant between 0 and 1.');
         end
         d=get(obj.popup , 'UserData');
         d.split = new_value;
         set(obj.popup , 'UserData' , d);
         p1 = get(obj.text, 'position');
         p2 = get(obj.popup, 'position');
         pos = [p1(1) p1(2) p1(3)+p2(3) p1(4)];
         set(obj, 'position',pos);
      case 'userdata'
         d=get(obj.popup , 'UserData');
         d.UserData = new_value;
         set(obj.popup , 'UserData' , d);
      case 'callback'
         d=get(obj.popup , 'UserData');
         d.callback = new_value;
         set(obj.popup , 'UserData' , d);
      case 'string'
         d=get(obj.popup , 'UserData');
         d.string = new_value;
         set(obj.popup , 'string' , new_value , 'UserData' , d);
      case 'value'
         set(obj.popup , 'value' , new_value );
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
out.Callback = 'String';
out.UserData = 'Anything.';
