%% Mandelbrot Chapter Recap
% This is an executable program that illustrates the statements
% introduced in the Mandelbrot Chapter of "Experiments in MATLAB".
% You can access it with
%
%    mandelbrot_recap
%    edit mandelbrot_recap
%    publish mandelbrot_recap
%
% Related EXM programs
%
%    mandelbrot

%% Define the region.
   x = 0: 0.05: 0.8;
   y = x';
   
%% Create the two-dimensional complex grid using Tony's indexing trick.
   n = length(x);
   e = ones(n,1);
   z0 = x(e,:) + i*y(:,e);

%% Or, do the same thing with meshgrid.
   [X,Y] = meshgrid(x,y);
   z0 = X + i*Y;

%% Initialize the iterates and counts arrays.
   z = zeros(n,n);
   c = zeros(n,n);

%% Here is the Mandelbrot iteration.
   depth = 32;
   for k = 1:depth
      z = z.^3 + z0;
      c(abs(z) < 2) = k;
   end

%% Create an image from the counts.
   c
   image(c)
   axis image

%% Colors
   colormap(flipud(jet(depth)))
