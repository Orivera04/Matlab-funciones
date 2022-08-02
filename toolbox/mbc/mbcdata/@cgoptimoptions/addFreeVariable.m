function obj = addFreeVariable(obj, sLabel)
%ADDFREEVARIABLE Add a free variable to the optimization.
%   OPTIONS = ADDFREEVARIABLE(OPTIONS, LABEL) adds a placeholder for a free
%   variable to the optimization.  The string LABEL will be used to refer
%   to the variable in the CAGE GUI.
%
%   See also CGOPTIMOPTIONS/SETFREEVARIABLESMODE,
%            CGOPTIMOPTIONS/GETFREEVARIABLESMODE,
%            CGOPTIMOPTIONS/GETFREEVARIABLES.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.6.6.1 $    $Date: 2004/02/09 06:52:32 $

if ~ischar(sLabel)
    error('mbc:cgoptimoptions:InvalidArgument', 'Free variable label must be a string.');
end

% Check that the label is unique to other free variables
ok = checklabel(obj, sLabel);
if ~ok
    error('mbc:cgoptimoptions:NonUniqueLabel', 'Free variable labels must be unique.');
end

% Check that there are no linear constraints
mylincon = getLinearConstraints(obj);
if ~isempty(mylincon)
    warning('mbc:cgoptimoptions:InvalidState', ...
        'Cannot add a free variable when there are linear constraints set up.');
else
    freevarmode = getFreeVariablesMode(obj);
    if ~strcmp(freevarmode, 'any')
        lbls = obj.freevariables.labels;    
        if obj.freevariables.firstcall
            N = 0;
            obj.freevariables.firstcall = 0;
        else
            N = length(lbls);
        end
        lbls{N + 1} = sLabel;        
        obj.freevariables.labels = lbls;
    else
        warning('mbc:cgoptimoptions:InvalidState', ...
            'Cannot add a free variable when free variable mode is set to ''any''.');
    end
end