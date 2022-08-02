%GETFRAME Get movie frame.
%	GETFRAME returns a column vector with one movie frame. The
%	frame is a snapshot (pixmap) of the current axis. GETFRAME
%	is usually used in a FOR loop to assemble movie matrix M 
%	for playback using MOVIE.  For example:
%
%	   M = moviein(n);
%	   for j=1:n
%	      plot_command
%	      M(:,j) = getframe
%	   end
%	   movie(M)
%
%	It is important to preallocate movie matrix M before building the
%	movie in order to prevent excessive memory use. The function
%	MOVIEIN is available for this purpose.
%
%	GETFRAME(H) gets a frame from object H, where H is a handle
%	to the root, a figure, or an axis.
%	GETFRAME(H,RECT) specifies the rectangle to copy the bitmap
%	from, relative to the lower-left corner of object H and in
%	the units of its Units property.
%
%	[X,MAP] = GETFRAME(H) or [X,MAP] = GETFRAME(H,RECT) returns the
%	frame as an indexed image matrix X and a colormap MAP.  H can 
%	be handle of a figure or axis.
%
%	See also MOVIE, MOVIEIN, CAPTURE.

%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	Built-in function.
