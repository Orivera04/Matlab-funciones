function str = getaliasstring(obj)
%GETALIASSTRING Return a string verion of the alias list
%
%  OUT = GETALIASSTRING(IN) returns a single-line string containing the
%  names of all of the aliases to this object.  The alias names will be
%  comma-separated.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 07:16:37 $ 

if ~isempty(obj.Alias)
    str = sprintf('%s, ', obj.Alias{:});
    str = str(1:end-2);                      % Trim final ", "
else
    str ='';
end