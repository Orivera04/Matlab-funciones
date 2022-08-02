%% Shallow Water Chapter Recap 
% This is an executable program that illustrates the statements
% introduced in the Shallow Water Chapter of "Experiments in MATLAB".
% You can access it with
% 
%    water_recap
%    edit water_recap
%    publish water_recap
%
% Related EXM programs
%
%    waterwave

%% Finite Differences
% A simple example of the grid operations in waterwave.

%% Create a two dimensional grid.

   m = 21;
   [x,y] = ndgrid(-1: 2/(m-1): 1);

%% The water drop function from waterwave.

   U = exp(-5*(x.^2+y.^2));

%% Surf plot of the function

   clf
   shg
   h = surf(x,y,U);
   axis off
   ax = axis;

%% Colormap

   c = (37:100)';
   cyan = [0*c c c]/100;
   colormap(cyan)
   pause(1)

%% Indices in the four compass directions.

   n = [2:m m];
   e = n;
   s = [1 1:m-1];
   w = s;

%% A relation parameter.  Try other values. 
% Experiment with omega slightly greater than one.

   omega = 1;

%% Relax.
% Repeatedly replace grid values by relaxed average of four neighbors.

   tfinal = 500;
   for t = 1:tfinal
      U = (1-omega)*U + omega*(U(n,:)+U(:,e)+U(s,:)+U(:,w))/4;
      set(h,'zdata',U);
      axis(ax)
      drawnow
   end
