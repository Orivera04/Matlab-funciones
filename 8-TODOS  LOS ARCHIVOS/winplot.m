function winplot(XX,YY,window,s)

% WINDOWPLOT
%	Plots the vector YY versus the vector XX and completely ignores 
%	the part not in the window designated by 
%	window = [ xmin,xmax,ymin,ymax].  This is useful, for example, 
%	in PHASEPLOT.
%
%	There is no way to sense if hold is on or off before entering
%	this routine.  A choice has to be made, so we assume that hold 
%	is ON when this routine is called.  It will then be ON when the 
%	routine is exited.

if (nargin < 4)
	s=['-r'];
end

A = find( (XX >= window(1)) & (XX <= window(2)) & (YY >= window(3)) & (YY <= window(4)));  	% Points in the window.


B = find( (XX < window(1)) | (XX > window(2)) | (YY < window(3)) | (YY > window(4)));		% Points not in the window.

D = A;

while (length(D) > 0)
	a0 = max(D(1)-1,1);
	C = find(B>a0);
	if (length(C) == 0)
		a1 = length(XX);

	else
		a1 = B(C(1));

	end
	plot(XX(a0:a1),YY(a0:a1),s);
	D = A(find(A>a1));
end
