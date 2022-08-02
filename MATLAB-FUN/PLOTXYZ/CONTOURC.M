%CONTOURC Contour computation.
%	CONTOURC calculates the contour matrix C for use by CONTOUR
%	to draw the actual contour plot.
%	C = CONTOURC(Z) computes the contour matrix for a contour plot
%	of matrix Z treating the values in Z as heights above a plane.
% 	C = CONTOURC(X,Y,Z), where X and Y are vectors, specifies the X- 
%	and Y-axes for the contour computation.
% 	CONTOURC(Z,N) and CONTOURC(X,Y,Z,N) compute N contour lines, 
% 	overriding the default automatic value.
% 	CONTOURC(Z,V) and CONTOURC(X,Y,Z,V) compute LENGTH(V) contour 
%	lines at the values specified in vector V.
% 	
% 	The contour matrix C is a two row matrix of contour lines. Each
%	contiguous drawing segment contains the value of the contour, 
%	the number of (x,y) drawing pairs, and the pairs themselves.  
%	The segments are appended end-to-end as
% 
% 	    C = [level1 x1 x2 x3 ... level2 x2 x2 x3 ...;
% 	         pairs1 y1 y2 y3 ... pairs2 y2 y2 y3 ...]
% 
%  	See also CONTOUR.

%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	Built-in function.
