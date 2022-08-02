function c=mult(a,b)
%MTIMES

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:40:36 $


a=polynom(a);
b=polynom(b);
c=a;

c.c = conv(a.c,b.c);