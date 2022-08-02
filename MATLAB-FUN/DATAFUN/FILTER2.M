function y = filter2(b,x,shape)
%FILTER2 Two-dimensional filtering.
%
%	Y = FILTER2(B,X) filters the data in X with the 2-D FIR
%	filter in the matrix B.  The result, Y, is computed 
%	using 2-D convolution and is the same size as X.
%
%	Y = FILTER2(B,X,'shape') returns Y computed via 2-D
%	convolution with size specified by 'shape':
%	  'same'  - (default) returns the central part of the 
%	            convolution that is the same size as X.
%	  'valid' - returns only those parts of the convolution
%	            that are computed without the zero-padded
%	            edges, size(Y) < size(X).
%	  'full'  - returns the full 2-D convolution, 
%	            size(Y) > size(X).
%
%	See also CONV2.

%	Clay M. Thompson 9-17-91
%	L. Shure 10-21-91, modified to use conv2 mex-file
%	Copyright (c) 1984-94 by The MathWorks, Inc.

error(nargchk(2,3,nargin));
if nargin<3, shape = 'same'; end

code = [shape,' ']; code = code(1);
if isempty(find(code=='svf')), error('Unknown shape parameter.'); end

[mx,nx] = size(x);
stencil = rot90(b,2);
[ms,ns] = size(stencil);

y = conv2(x,stencil,shape);
