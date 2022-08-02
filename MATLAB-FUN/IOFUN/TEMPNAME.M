function tmp_name = tempname()
%TEMPNAME Returns a unique name suitable for use as a temporary file

%	Marc Ullman  2-8-93
%	Copyright (c) 1984-94 by The MathWorks, Inc.

t0 = clock;

while(1)
	% loop in place until the time changes, so we can get a unique
	% filename (won't take very long)
	t = clock;
	if (fix(t0(6)*100) ~= fix(t(6)*100))
		break;
	end
end

tmp_name = [tempdir sprintf('tp%02.0f%04.0f', t(5), t(6)*100)];
