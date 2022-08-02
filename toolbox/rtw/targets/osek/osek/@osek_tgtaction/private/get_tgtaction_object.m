% File : get_tgtaction_object(obj)
%
% Abstract :
%   Return the toolchain specific tgtaction object

% Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.2.4.1 $
%   $Date: 2004/04/19 01:30:57 $
function t_obj = get_tgtaction_object(obj)

toolchain = get_current_toolchain;

switch lower(toolchain)
case 'osek_singlestep'
    % Compiler specific support
    t_obj = osek_singlestep_tgtaction;
case 'osek_custom'
    % Compiler specific support
    t_obj = osek_custom_tgtaction;

otherwise
    error([toolchain ' is not supported by the tgtaction dispatch mechanism.']);
end

