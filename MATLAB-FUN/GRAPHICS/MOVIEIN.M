function M = moviein(n,h,rect)
%MOVIEIN Initialize memory for saving movie frames.
%	M = MOVIEIN(N) creates a matrix large enough to hold N frames
%	of a movie based on the current axis.  The matrix has enough
%	rows to store N copies of the output from GETFRAME, one in each
%	column.
%
%	M = MOVIEIN(N,H) and M = MOVIEIN(N,H,RECT) pass the optional
%	graphics handle, H, and optional position rectangle, RECT, on
%	to GETFRAME(H,RECT) to specify graphics objects other than the
%	default current axis.
%	
%	Example:  To generate a movie with n frames,
%
%	    M = moviein(n);
%	    for j=1:n
%	       plot_command
%	       M(:,j) = getframe
%	    end
%	    movie(M)
%
%	To generate a movie whose frames contain the entire figure,
%	not just the current axis, 
%
%	    M = moviein(n,gcf)    
%
%	See also MOVIE, GETFRAME.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

if nargin == 1
   M = zeros(length(getframe),n);
elseif nargin == 2
   M = zeros(length(getframe(h)),n);
else
   M = zeros(length(getframe(h,rect)),n);
end
