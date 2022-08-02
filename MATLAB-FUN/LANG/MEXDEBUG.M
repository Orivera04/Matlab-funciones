function mexdebug(arg)
%MEXDEBUG Enable MEX-file debugging.
%	MEXDEBUG ON enables MEX-file debugging.
%	MEXDEBUG OFF disables MEX-file debugging.
%	MEXDEBUG STOP returns to debugger prompt (except on VMS).
%	MEXDEBUG PRINT displays MEX-file debugging information.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

if any(getenv('MATLAB_DEBUG')) | isvms  % in VMS you don't run MATLAB with the debugger
    if nargin < 1, arg = 'on'; end
    if strcmp(arg,'stop')
        system_dependent(9);
    elseif strcmp(arg,'print')
	    system_dependent(8,2);
    else
        system_dependent(8,strcmp(arg,'on'));
    end
else
    disp(' ')
    disp('In order to debug MEX-files, MATLAB must be run within a debugger.');
    disp(' ')
    disp('    To run MATLAB within a debugger start it by typing:');
    disp('           matlab -Ddebugger');
    disp('    where "debugger" is the name of the debugger you wish to use.');
    disp(' ')
end
