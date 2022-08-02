function s = isstudent(x)
%ISSTUDENT True for MATLAB Student Edition.
%	ISSTUDENT returns 1 for Student Editions of MATLAB
%	and 0 for full-sized editions.
%
%	See also COMPUTER.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

[ignore, matsize] = computer;
s = (matsize == 8192);
