function rsummer(f,n)
%RSUMMER Evaluate and display Riemann sum.
%	RSUMMER('expr',n) displays a graph of the Riemann sum
%	for 'expr' using n points on [0,1].

%	Copyright (c) 1993-94 by The MathWorks, Inc.
%	$Revision: 1.5 $  $Date: 1994/01/24 22:37:08 $

x = (1:n)/n;
y = eval(vectorize(f));
r = sum(y)/n;
bar(x,y)
title([f '  :  ' sprintf('%9.6f',r)])
xlabel(int2str(n))
axis([0 1 min(0,min(y)) max(0,max(y))])
