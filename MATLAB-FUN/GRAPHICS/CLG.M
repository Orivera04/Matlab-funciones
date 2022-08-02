function clg(arg1);
%CLG 	Clear Figure (graph window).
%	CLG is a pseudonym for CLF, provided for upward compatibility
%	from MATLAB 3.5.
%	See also CLF.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

if(nargin == 0)
	clf;
else
	clf(arg1);
end

