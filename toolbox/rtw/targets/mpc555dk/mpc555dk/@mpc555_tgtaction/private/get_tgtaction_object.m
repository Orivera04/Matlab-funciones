% File : get_tgtaction_object(obj)
%
% Abstract :
%   Return the toolchain specific tgtaction object

% Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.1.4.1 $
%   $Date: 2004/04/19 01:26:45 $
function t_obj = toolchain_tgtaction(obj)

toolchain = get_current_toolchain;
switch lower(toolchain)
case {'cw' 'codewarrior'}
    % Compiler specific support
    t_obj = codewarrior_tgtaction;
case 'diab'
    % Compiler specific support
    t_obj = diab_tgtaction;
otherwise
    error([toolchain ' is not supported by the tgtaction dispatch mechanism.']);
end

