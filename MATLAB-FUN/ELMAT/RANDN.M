%RANDN	Normally distributed random numbers and matrices.
%	RANDN(N) is an N-by-N matrix with random entries, chosen
%	from a normal distribution with mean 0.0 and variance 1.0.
%	RANDN(M,N) or RANDN([M,N]) is an M-by-N matrix with random entries.
%	RANDN(SIZE(A)) is the same size as A.
%	RANDN with no arguments is a scalar whose value changes each time
%	it is referenced.
%
%	RANDN('seed') returns the current seed of the normal generator.
%	RANDN('seed',s) sets the normal generator seed to s.
%	RANDN('seed',0) resets the seed its startup value.
%	RANDN('seed',sum(100*clock)) sets it to a different value each time.
%
%	RANDN and RAND have separate generators, each with its own seed.
%
%	See also RAND, SPRANDN.

%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	Built-in function.
