function obj = addOperatingPointSet(obj, sLabel, vars)
%ADDOPERATINGPOINTSET Add an operating point set to the optimization.
%   OPTIONS = ADDOPERATINGPOINTSET(OPTIONS, LABEL, VARS) adds a placeholder
%   for an additional operating point set to the optimization. The string
%   LABEL will be used to refer to the operating point set in the CAGE GUI.
%   VARS is a (1-by-N) cell array of strings, where N >= 1.  Each element
%   of VARS is a label for a CAGE variable that must appear in the
%   operating point set that the user chooses.
%
%   See also CGOPTIMOPTIONS/GETOPERATINGPOINTSETS, 
%            CGOPTIMOPTIONS/SETOPERATINGPOINTSMODE,
%            CGOPTIMOPTIONS/GETOPERATINGPOINTSMODE.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.5.6.2 $    $Date: 2004/02/09 06:52:36 $

% Some sanity checks
if nargin < 3
    error('mbc:cgoptimoptions:InvalidArgument', 'ADDOPERATINGPOINTSET requires three inputs.');
end

% Check input types
[ok, msg] = i_CheckInputs(obj, {sLabel, vars});
if ~ok
    error('mbc:cgoptimoptions:InvalidArgument',msg);
end

% Check that the label is unique to other objectives
ok = checklabel(obj, sLabel);
if ~ok
    error('mbc:cgoptimoptions:NonUniqueLabel', 'Objective labels must be unique.');
end

opsmode = getOperatingPointsMode(obj);
if isempty(strmatch(opsmode, {'default', 'any'}))
    oppts = obj.operatingpoints.details;
    N = length(oppts);
    oppts(N+1).label = sLabel;
    oppts(N+1).vars = vars;       
    obj.operatingpoints.details = oppts;
else
    warning('mbc:cgoptimoptions:InvalidState', ...
        'Cannot add an operating point set when operating point sets mode is set to ''any'' or ''default''.');
end


%----------------------------------------------------------------------
function [ok, msg] = i_CheckInputs(opt, in)
%----------------------------------------------------------------------

ok = false; msg = '';

if ~ischar(in{1}) || isempty(in{1})
    msg = 'The label must be a non-empty string.';
elseif ~iscell(in{2}) 
    msg = 'The required variables input must be a cell array of strings.';
elseif ~all(cellfun('isclass', in{2}, 'char'))
    msg = 'The required variables input must be a cell array of strings.';
elseif (size(in{2}, 1) ~= 1) || (ndims(in{2}) ~= 2)
    msg = 'The required variables input must be a (1-by-N) cell array.';
else
    ok = true;
end