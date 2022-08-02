function obj = setConstraintsMode(obj, sMode)
%SETCONSTRAINTSMODE Set how the optimization constraints are to be used.
%   OPTIONS = SETCONSTRAINTSMODE(OPTIONS, MODESTR) sets the mode that
%   governs how the user will be allowed to set up constraints for the
%   optimization in the CAGE GUI.  When MODESTR = 'any', the user will be
%   allowed to add any number of constraints.   When MODESTR = 'fixed', the
%   user will only be allowed to edit the constraints that are added by the
%   user-defined optimization function.
%
%   See also CGOPTIMOPTIONS/GETCONSTRAINTSMODE,
%            CGOPTIMOPTIONS/ADDLINEARCONSTRAINT,
%            CGOPTIMOPTIONS/ADDMODELCONSTRAINT.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.5.6.1 $    $Date: 2004/02/09 06:54:12 $

if nargin < 2
    error('mbc:cgoptimoptions:InvalidArgument', 'SETCONSTRAINTSMODE requires two inputs.');
end

% Check input types
[ok, msg] = i_CheckInputs(obj, {sMode});
if ~ok
    error('mbc:cgoptimoptions:InvalidArgument', msg);
end

if strcmp(sMode, 'any')
    % All existing constraints must be cleared
    obj.constraints.details = struct('label', '', 'typestr', '', 'pars', {});
end
obj.constraints.mode = sMode;



%----------------------------------------------------------------------
function [ok, msg] = i_CheckInputs(obj,in)
%----------------------------------------------------------------------

ok = false; msg = '';

if ~ischar(in{1}) || isempty(in{1}) || isempty(strmatch(in{1}, {'any', 'fixed'}, 'exact'))
    msg = 'The mode must be either ''any'' or ''fixed''.';
else
   ok = true;
end