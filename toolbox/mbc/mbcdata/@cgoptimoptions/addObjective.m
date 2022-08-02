function obj = addObjective(obj, sLabel, sType)
%ADDOBJECTIVE Add an objective to the optimization.
%   OPTIONS = ADDOBJECTIVE(OPTIONS, LABEL, TYPESTR) adds a placeholder for
%   an objective function to the optimization.  The string LABEL will be
%   used to refer to the constraint in the CAGE GUI.  TYPESTR can take one
%   of four values, 'max', 'min', 'min/max' or 'helper'. 
%
%   Examples:
%     opt = addObjective(opt, 'newObj', 'max') adds an objective function
%     labelled newObj to the optimization and indicates that it is to be
%     maximized.
%
%     opt = addObjective(opt, 'newObj', 'min/max') adds an objective
%     function labelled newObj to the optimization and indicates that the
%     user should be allowed to choose whether it is minimized or maximized
%     from the CAGE GUI.
%
%     opt = addObjective(opt, 'newObj2', 'helper') adds an objective
%     function labelled newObj2 to the optimization.  The string 'helper'
%     indicates that the function will be used as part of the determination
%     of the cost function but will not be directly minimized or maximized.
%
%   See also CGOPTIMOPTIONS/GETOBJECTIVES,
%            CGOPTIMOPTIONS/SETOBJECTIVESMODE,
%            CGOPTIMOPTIONS/GETOBJECTIVESMODE.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.6.6.1 $    $Date: 2004/02/09 06:52:35 $

% Some sanity checks
if nargin < 3
    error('mbc:cgoptimoptions:InvalidArgument', 'ADDOBJECTIVE requires three inputs.');
end

% Check input types
[ok, msg] = i_CheckInputs(obj, {sLabel, sType});
if ~ok
    error('mbc:cgoptimoptions:InvalidArgument',msg);
end

% Check that the label is unique to other objectives
ok = checklabel(obj, sLabel);
if ~ok
    error('mbc:cgoptimoptions:NonUniqueLabel', 'Objective labels must be unique.');
end

objmode = getObjectivesMode(obj);
if isempty(strmatch(objmode, {'multiple', 'any'})) 
    objs = obj.objectives.details;
    if obj.objectives.firstcall
        N = 0;
        obj.objectives.firstcall = 0;
    else
        N = length(obj.objectives.details);
    end
    objs(N+1).label = sLabel;
    objs(N+1).type = sType;
    obj.objectives.details = objs;
else
    warning('mbc:cgoptimoptions:InvalidState', ...
        'Cannot add an objective when objective mode is set to ''any'' or ''multiple''.');
end


%----------------------------------------------------------------------
function [ok, msg] = i_CheckInputs(opt, in)
%----------------------------------------------------------------------
ok = false; msg = '';

if ~ischar(in{1}) || isempty(in{1})
    msg = 'The label must be a non-empty string.';
elseif ~ischar(in{2})
    msg = 'The objective type must be a string.';
elseif isempty(strmatch(in{2}, {'max', 'min', 'min/max','helper'}, 'exact'))
    msg = 'The objective type must be ''max'', ''min'' or ''helper''.';  
else
    ok = true;
end