function display(UnitObj)
%DISPLAY

%  Copyright 2000-2004 The MathWorks, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:43:26 $

%JUNIT/DISPLAY  Display function for unit objects, called for assignments
%   without a terminating semicolon.
%
%   DISPLAY(UnitObj) displays a human-readable representation of a junit
%   object.
%
%   See also CHAR.

% ---------------------------------------------------------------------------
% Description : Method to display a junit object
% Inputs      : UnitObj - junit object (junit)
% ---------------------------------------------------------------------------

% Display a blank line first if FormatSpacing is loose
loose = isequal(get(0,'FormatSpacing'),'loose');
if loose,
    disp(' ');
end

% Display "VariableName ="
disp([inputname(1) ' =']);

% Display a blank line again if FormatSpacing is loose
if loose,
    disp(' ');
end

% All the work is done by the char method
disp(char(UnitObj, ' (invalid)'));