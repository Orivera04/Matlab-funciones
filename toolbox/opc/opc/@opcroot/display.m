function display(obj)
%DISPLAY Display OPC Toolbox objects.
%   DISPLAY(Obj) shows the name and description of the OPC Toolbox object
%   Obj.

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd.
% $Revision: 1.1.6.3 $  $Date: 2004/03/24 20:43:25 $

% Initialize formatting variables.
if strcmp(get(0,'FormatSpacing'),'loose'),
    newline=sprintf('\n');
else
    newline=sprintf('');
end

% Now show my output name if possible:
fprintf(1, [newline, inputname(1), ' =\n']);

% Determine if we need to display a single object or an array.
nObjs = length(obj);
if nObjs==1,
    % >> obj
    disp(obj);
else
    arraydisp(obj)
end
