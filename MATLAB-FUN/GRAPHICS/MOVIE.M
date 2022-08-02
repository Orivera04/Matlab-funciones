%MOVIE	Play recorded movie frames.
% 	MOVIE(M) plays the movie in matrix M once. M must be a matrix
%	whose columns are movie frames (usually from GETFRAME).
%	MOVIE(M,N) plays the movie N times. If N is negative, each
%	"play" is once forward and once backward. If N is a vector,
%	elements 2 and above specify the order in which to play the
%	frames. For example, if M has three columns, N = [10 3 2 1]
%	plays the movie ten times backwards.
%	MOVIE(M,N,FPS) plays the movie at FPS frames per second. The
%	default if FPS is omitted is 12 frames per second. Machines 
%	that can't achieve the specified FPS play as fast as they can.
%
%	MOVIE(H,...) plays the movie in object H, where H is a handle
%	to the root, a figure, or an axis.
%	MOVIE(H,M,N,FPS,LOC) specifies the location to play the movie
%	at, relative to the lower-left corner of object H and in
%	the units of its Units property. LOC = [X Y].
%
%	See also GETFRAME, MOVIEIN.

%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	Built-in function.
