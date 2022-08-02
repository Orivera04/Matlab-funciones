function h = loadobj(command,data);
% LOADOBJ Restores a saved object
% loadobj(command,data) recreates an object
% stored with saveobj.
% 
% See Also:  saveobj
%
% Keith Rogers  6/97

% Mods:

% Copyright (c) 1997 by Keith Rogers
for(i=1:length(data))
	eval([data(i).prop '=  data(i).val;']);
end
eval(['h = ' command]);
