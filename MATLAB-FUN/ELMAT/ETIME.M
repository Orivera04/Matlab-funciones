function t = etime(t1,t0)
%ETIME	Elapsed time.
%	ETIME(T1,T0) returns the time in seconds that has elapsed between
%	vectors T1 and T0.  The two vectors must be six elements long, in
%	the format returned by CLOCK:
%
%	    T = [Year Month Day Hour Minute Second]
%
%	Here's an example of using ETIME to time an operation:
%
%	  t0 = clock;
%	  operation
%	  etime(clock,t0)
%
%	Caution: As currently implemented, it won't work across month or year
%	boundaries.  It is an M-file, so it can be fixed if you require this.
%
%	See also TIC, TOC, CLOCK, CPUTIME.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

t = (t1 - t0) * [0 0 86400 3600 60 1]';
