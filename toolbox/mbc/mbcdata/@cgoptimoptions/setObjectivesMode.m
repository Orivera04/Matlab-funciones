function obj = setObjectivesMode(obj, sMode)
%SETOBJECTIVESMODE Set how the optimization objective functions are used 
%   OPTIONS = SETOBJECTIVESMODE(OPTIONS, MODESTR) sets the mode that
%   governs how the user will be allowed to set up objectives for the
%   optimization in the CAGE GUI.  When MODESTR = 'any', the user will be
%   allowed to add any number of objectives.   When MODESTR = 'fixed', the
%   user will only be allowed to edit the objectives that are added by the
%   user-defined optimization function.  When MODESTR = 'multiple', the
%   user will be only be allowed to run the optimization if they have
%   defined two or more objectives.
%
%   See also CGOPTIMOPTIONS/GETOBJECTIVESMODE,
%            CGOPTIMOPTIONS/ADDOBJECTIVE.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.7.6.1 $    $Date: 2004/02/09 06:54:17 $

if nargin < 2
    error('mbc:cgoptimoptions:InvalidArgument', 'SETOBJECTIVESMODE requires two inputs.');
end

% Check input types
[ok, msg] = i_CheckInputs(obj, {sMode});
if ~ok
    error('mbc:cgoptimoptions:InvalidArgument', msg);
end

if ~isempty(strmatch(sMode, 'any'))
    % All existing datasets must be cleared
    obj.objectives.details = struct('label', 'Objective1', 'type', 'min/max');
elseif ~isempty(strmatch(sMode, 'multiple'))
    % All existing datasets must be cleared
    obj.objectives.details = struct('label', 'Objective1', 'type', 'min/max');    
    obj.objectives.details(2).label = 'Objective2';
    obj.objectives.details(2).type = 'min/max';
elseif strcmp(sMode, 'fixed') && (length(obj.operatingpoints.details) == 0)
    objs.label = 'Objective1';
    objs.type = 'min/max';
    obj.objectives.details = objs;
    obj.objectives.firstcall = 1;
end
obj.objectives.mode = sMode;




%----------------------------------------------------------------------
function [ok, msg] = i_CheckInputs(obj,in)
%----------------------------------------------------------------------

ok = false; msg = '';

if ~ischar(in{1}) || isempty(in{1}) || isempty(strmatch(in{1}, {'any', 'fixed', 'multiple'}, 'exact'))
    msg = 'The mode must be either ''any'', ''fixed'' or ''multiple''.';
else
   ok = true;
end