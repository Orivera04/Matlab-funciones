function t = toc
%TOC	Read the stopwatch timer.
%	TOC, by itself, prints the elapsed time since TIC was used.
%	t = TOC; saves the elapsed time in t, instead of printing it out.
%
%	See also TIC, ETIME, CLOCK, CPUTIME.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

% TOC uses ETIME and the value of CLOCK saved by TIC.
global TICTOC
if nargout < 1
   elapsed_time = etime(clock,TICTOC)
else
   t = etime(clock,TICTOC);
end
