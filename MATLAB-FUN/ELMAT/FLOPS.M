%FLOPS	Count of floating point operations.
% 	FLOPS returns the cumulative number of floating point 
% 	operations. FLOPS(0) resets the count to zero.
% 	It is not feasible to count absolutely all floating point
% 	operations, but most of the important ones are counted.
% 	Additions and subtractions are one flop if real and two if
% 	complex. Multiplications and divisions count one flop each
% 	if the result is real and six flops if it is not.
% 	Elementary functions count one if real and more if complex.
% 	Some examples. If A and B are real N-by-N matrices, then
% 	        A + B   counts N^2 flops,
% 	        A * B   counts 2*N^3 flops,
% 	        A ^ 100 counts 99*2*N^3 flops,
% 	        LU(A)   counts roughly (2/3)*N^3 flops.

%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	Built-in function.
