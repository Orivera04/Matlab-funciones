function y=mmbytes(arg)
%MMBYTES Variable Memory Usage. (MM)
% MMBYTES and MMBYTES('base') returns the total memory in bytes
% currently used in the base workspace.
% MMBYTES('caller') returns the total memory in bytes currently
% used in the workspace where MMBYTES is called from.
% MMBYTES('global') returns the total memory in bytes currently
% used in the global workspace.

% D.C. Hanselman, University of Maine, Orono, ME  04469
% 5/20/99
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin==0
   arg='base';
end
if strcmp(arg,'global')
   x=evalin('base','whos(''global'')');
else
   x=evalin(arg,'whos');
end
y=sum(cat(1,x.bytes));
