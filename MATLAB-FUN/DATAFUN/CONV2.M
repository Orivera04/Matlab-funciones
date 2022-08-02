function c = conv2(arg1,arg2,shape)
%CONV2	Two dimensional convolution.
%	C = CONV2(A, B) performs the 2-D convolution of matrices
%	A and B.   If [ma,na] = size(A) and [mb,nb] = size(B), then 
%	size(C) = [ma+mb-1,na+nb-1]. 
%
%	C = CONV2(A,B,'shape') returns a subsection of the 2-D
%	convolution with size specified by 'shape':
%	  'full'  - (default) returns the full 2-D convolution, 
%	  'same'  - returns the central part of the convolution 
%	            that is the same size as A.
%	  'valid' - returns only those parts of the convolution
%	            that are computed without the zero-padded
%	            edges, size(C) = [ma-mb+1,na-nb+1] when
%	            size(A) > size(B).
%	CONV2 is fastest when size(A) > size(B).
%
%	See also XCORR2, CONV, XCORR, DECONV, FILTER2.

%	Marc Ullman   2-6-86
%	Revised 2-18-87 J.N. Little
%	Revised 10-22-91 L. Shure, C. Thompson
%	Copyright (c) 1984-94 by The MathWorks, Inc.

error(nargchk(2,3,nargin));
if nargin<3, shape = 'full'; end

code = [shape,' ']; code = code(1);
if isempty(find(code=='svf')), error('Unknown shape parameter.'); end

if prod(size(arg1))<prod(size(arg2)), % Use smaller matrix for b.
  [mu,nu] = size(arg2);
  [mb,nb] = size(arg1);
  c = zeros(mb+mu-1,nb+nu-1);
  rows = 0:mu-1;
  cols = 0:nu-1;
  for j=1:nb
	for i=1:mb
		w = arg1(i,j);
		if w~=0,
			c(i+rows,j+cols) = c(i+rows,j+cols) + w*arg2;
		end
	end
  end
  switched = 1;
else
  [mu,nu] = size(arg1);
  [mb,nb] = size(arg2);
  c = zeros(mb+mu-1,nb+nu-1);
  rows = 0:mu-1;
  cols = 0:nu-1;
  for j=1:nb
	for i=1:mb
		w = arg2(i,j);
		if w~=0,
			c(i+rows,j+cols) = c(i+rows,j+cols) + w*arg1;
		end
	end
  end
  switched = 0;
end
  
if code=='s',
  % Return the central part that is the same size as the original U.
  if switched,
    rows = floor(mu/2) + (1:mb);
    cols = floor(nu/2) + (1:nb);
    c = c(rows,cols);
  else
    rows = floor(mb/2) + (1:mu);
    cols = floor(nb/2) + (1:nu);
    c = c(rows,cols);
  end

elseif code == 'v',
  % Return the central part that is computed without the padded edges.
  rows = mb-1 + (1:mu-mb+1);
  cols = nb-1 + (1:nu-nb+1);
  c = c(rows,cols);
end
