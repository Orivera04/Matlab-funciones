%  movie_demo.m
%
%  This is a demonstration of how to make and display a movie
%  in MATLAB.  We are going to simply make a series of PLOT's,
%  saving each one in a data structure we'll call "FRAMES".
%
%  As each plot is made, it will show up on the screen.
%
%  But by saving each plot as the next frame in our movie,
%  we can display our results in an animation.
%
nframes = 51;
%
%  Here we are telling MATLAB that we want to store a movie
%  of NFRAMES frames in a variable we'll call MY_FRAMES.
%
my_frames = moviein ( nframes );
%
%  Set up the X positions where we will sample the function.
%
XMIN = - 12.0;
XMAX = + 12.0;
nx = 51;
x = linspace ( XMIN, XMAX, nx );
%
%  We happen to know that our raw Y values will always lie between -1 and 1,
%  but we're going to scale them.
%
YSCALE = 5.0
YMIN = - YSCALE;
YMAX = + YSCALE;
%
%  Generate the frames.
%
%  "GETFRAME" is a MATLAB command that stores the current plot in
%  our MOVIEIN datastructure.
%
for i = 1 : nframes

  i
  t = 2 * ( i - 1 ) * pi / ( nframes - 1 );
  y = YSCALE * cos ( 2.0 * x / XMAX ) .* sin ( t ) .* cos ( t + x );
  plot ( x, y )
%
%  Use this AXIS command:
%
% axis ( [ XMIN, XMAX, YMIN, YMAX ] );
%
%  Or this one:
%
  axis equal
  my_frames(:,i) = getframe;

end
%
%  Now show the entire set of frames as a movie, twice.
%
movie ( my_frames, 2 )

