%VMS	Execute VMS DCL system command.
%	[status,result] = vms('command'), for VMS systems, calls upon
%	the CLI to execute the given command.  The resulting status, 
%       output and error messages are returned.
%
%	Examples:
%
%	    [s,w] = vms('show users')
%
%	returns a success status in s and, in w, a MATLAB string containing
%       a list of the users currently logged in.
%
%
%	    [s,w] = vms('why')
%
%	returns a failure status in s and sets w to the error message
%
%       %DCL-W-IVVERB, unrecognized command verb - check validity and spelling
%        \WHY\
%
%	because "why" is not a VMS DCL command.
%
%
%       If bit 0 of the exit status is set, the command was successful.
%       One way to check if this bit is set is to check if fix(s/2) ~= s/2.
%
%
%	See also ! (exclamation point) under PUNCT.

%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	Built-in function.
