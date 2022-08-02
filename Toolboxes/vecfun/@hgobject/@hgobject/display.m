function display(hgo)
%DISPLAY Display method for HGOBJECTS.

% D.C. Hanselman, University of Maine, Orono, ME  04469-5708
% masteringmatlab@yahoo.com
% 2007-06-22

loose=strcmp(get(0,'FormatSpacing'),'loose');
if loose
   disp(' ')
end
var=inputname(1);
if isempty(var)
   disp('ans =')
else
   disp([var ' ='])
end
disp(sprintf('HGOBJECT containing %d graphics handles of type ''%s''',length(hgo.handles),hgo.type))
if loose
   disp(' ')
end
