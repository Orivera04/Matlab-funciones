function obj = setOperatingPointsMode(obj, sMode)
%SETOPERATINGPOINTSMODE Set how the optimization operating point sets are used.
%   OPTIONS = SETOPERATINGPOINTSMODE(OPTIONS, MODESTR) sets the mode that
%   governs how the user will be allowed to set up operating point sets for
%   the optimization in the CAGE GUI.  When MODESTR = 'any', the user will
%   be allowed to add any number of operating point sets.   When MODESTR =
%   'default', the user will be allowed to optionally define a single
%   operating point set to run the optimization over.  When MODESTR =
%   'fixed', the number of operating point sets required can be fixed by
%   the optimization function and the user will not be allowed to add or
%   remove any using the CAGE GUI.
%
%   See also CGOPTIMOPTIONS/GETOPERATINGPOINTSMODE,
%            CGOPTIMOPTIONS/ADDOPERATINGPOINTSET.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.5.6.2 $    $Date: 2004/02/09 06:54:18 $

if nargin < 2
    error('mbc:cgoptimoptions:InvalidArgument', 'SETOPERATINGPOINTSMODE requires two inputs.');
end

% Check input types
[ok, msg] = i_CheckInputs(obj, {sMode});
if ~ok
    error('mbc:cgoptimoptions:InvalidArgument', msg);
end

if ~isempty(strmatch(sMode, {'any', 'default'}))
    % All existing datasets must be cleared
    obj.operatingpoints.details = struct('label', '', 'vars', {});
end
obj.operatingpoints.mode = sMode;

%----------------------------------------------------------------------
function [ok, msg] = i_CheckInputs(obj,in)
%----------------------------------------------------------------------

ok = false; msg = '';

if ~ischar(in{1}) || isempty(in{1}) || isempty(strmatch(in{1}, {'any', 'fixed', 'default'}, 'exact'))
    msg = 'The mode must be either ''any'', ''fixed'' or ''default''.';
else
   ok = true;
end