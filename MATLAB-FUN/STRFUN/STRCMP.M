function c = strcmp(s1,s2)
%STRCMP	String comparison.
%	STRCMP(S1,S2) returns 1 if strings S1
%	and S2 are the same and 0 otherwise.
%	See also FINDSTR.

%	J.N. Little 10-5-87, JRG 7-20-91.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

c = 0;
if all(size(s1) == size(s2))
    if all(all(s1 == s2))
        c = 1;
    end
end
