function t = isreal(x)
%ISREAL True for matrix that contains only real elements.
%	ISREAL(X) returns 1 if all elements in X have zero
%	imaginary part.

%	Clay M. Thompson 10-9-92
%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	$Revision: 1.5 $  $Date: 1994/01/25 15:58:33 $

t = all(all(imag(x)==0));

