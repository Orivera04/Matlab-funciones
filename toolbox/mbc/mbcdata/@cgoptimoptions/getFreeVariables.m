function labels = getFreeVariables(obj)
%GETFREEVARIABLES Return the optimization free variable labels.
%   LABELS = GETFREEVARIABLES(OPTIONS) returns the current placeholder
%   labels for the free variables in the optimisation.  The labels are
%   returned in a (1-by-NFreeVar) cell array, LABELS, where NFreeVar is the
%   number of free variables that have been added to the optimization.
%
%   See also CGOPTIMOPTIONS/ADDFREEVARIABLE,
%            CGOPTIMOPTIONS/SETFREEVARIABLESMODE,
%            CGOPTIMOPTIONS/GETFREEVARIABLESMODE.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.4.6.1 $    $Date: 2004/02/09 06:52:42 $

labels = obj.freevariables.labels;