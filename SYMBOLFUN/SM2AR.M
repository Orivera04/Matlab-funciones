function A = sm2ar(A)
%SM2AR	Convert symbolic matrix to Maple array.
%	A = SM2AR(M) converts a numeric matrix or a symbolic matrix to the
%	'array([[...],[...]])' form expected by Maple linear algebra functions.
%
%	See also AR2SM.

%	Copyright (c) 1993-94 by The MathWorks, Inc.
%	$Revision: 1.4 $  $Date: 1994/01/24 22:37:12 $

if ~isstr(A)
   A = sym(A);
end
A = [A setstr(','*ones(size(A(:,1))))]';
A = A(:)';
A(length(A)) = [];
A(find(A==' ')) = [];
A = ['array([' A '])'];
