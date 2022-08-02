%RAND	Uniformly distributed random numbers and matrices.
%	RAND(N) is an N-by-N matrix with random entries, ordinarily
%	chosen from a uniform distribution on the interval (0.0,1.0).
%	RAND(M,N) or RAND([M,N]) is an M-by-N matrix with random entries.
%	RAND(SIZE(A)) is the same size as A.
%	RAND with no arguments is a scalar whose value changes each time
%	it is referenced.
%
%	RAND('seed') returns the current seed of the uniform generator.
%	RAND('seed',s) sets the uniform generator seed to s.
%	RAND('seed',0) resets the seed its startup value.
%	RAND('seed',sum(100*clock)) sets it to a different value each time.
%
%	By default, RAND samples a uniform distribution.  The function
%	RANDN generates normally distributed random matrices.
%	RAND and RANDN have separate generators, each with its own seed.
%
%	Previous versions of MATLAB allowed RAND('normal') to switch
%	the prevailing distribution to normal, RAND('uniform') to switch
%	back to uniform distribution, and RAND('dist') to return a string
%	containing the prevailing distribution, either 'uniform' or 'normal'.
%	MATLAB Version 4.0 continues to allow this switch, but
%	issues a warning message discouraging its use.
%
%	See also RANDN, SPRANDN.

%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	Built-in function.
