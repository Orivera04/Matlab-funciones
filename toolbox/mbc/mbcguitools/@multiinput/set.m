function varargout = set(obj , varargin)
%SET

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:19:14 $

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
         fixed_i = find(obj.colsize >= 0);
         move_i = find(obj.colsize < 0);
         fixed = sum(obj.colsize(fixed_i)) + obj.gapx*(length(obj.colsize)-1);
         if length(move_i)>0
             avail = floor((new_value(3) - fixed)./length(move_i));
             if avail<1, avail = 1; end
         end
         pos = new_value;
         for i = 1:length(obj.objects)
             if obj.colsize(i)<0
                 pos(3) = avail;
             else
                 pos(3) = obj.colsize(i);
             end
             set(obj.objects{i},'position',pos);
             pos(1) = pos(1) + obj.gapx + pos(3);
         end
     case {'colsizes','colsize'}
         if ~isnumeric(new_value) | length(new_value)~=length(obj.objects)
             error('MultiInput::Set: Colsize must match number of objects.');
         end
         obj.colsize = new_value;
         
     case 'gapx'
         if ~isnumeric(new_value) | length(new_value)~=1
             error('MultiInput::Set: gapx must be a constant.');
         end
         obj.gapx = new_value;
         
      case 'visible'
          for i = 1:length(obj.objects)
              set(obj.objects{i},'visible',new_value);
          end
          
      case 'parent'
         if ~ishandle(new_value) | ~strcmp(lower(get(new_value , 'type')) , 'figure')
            error('PopupInput::Set: Invalid figure handle.');
         end
          for i = 1:length(obj.objects)
              set(obj.objects{i},'parent',new_value);
          end
      case 'value'
          for i = 1:length(obj.objects)
              if isa(obj.objects{i},'textinput') & ischar(new_value{i})
                  set(obj.objects{i},'varname',new_value{i});
              else
                  set(obj.objects{i},'value',new_value{i});
              end
          end
          
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
out.gapx = 'gap between elements';
out.colsizes = 'column width (-1 for unfixed)';
out.value = 'Cell array of values for elements';
