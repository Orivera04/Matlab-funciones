function tic
%TIC	Start a stopwatch timer.
%	The sequence of commands
%	    TIC
%	    any stuff
%	    TOC
%	prints the time required for the stuff.
%
%	See also TOC, CLOCK, ETIME, CPUTIME.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

% TIC simply stores CLOCK in a global variable.
global TICTOC
TICTOC = clock;
