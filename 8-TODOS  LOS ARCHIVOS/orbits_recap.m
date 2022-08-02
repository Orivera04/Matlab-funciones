%% Orbits Chapter Recap 
% This is an executable program that illustrates the statements
% introduced in the Orbits Chapter of "Experiments in MATLAB".
% You can access it with
%
%    orbits_recap
%    edit orbits_recap
%    publish orbits_recap
%
% Related EXM programs
%
%    bouncer
%    orbits

%% Core of bouncer, simple gravity. no gravity

   % Initialize

   z0 = eps;
   g = 9.8;
   c = 0.75;
   delta = 0.005;
   v0 = 21;
   y = [];

   % Bounce 

   while v0 >= 1
      v = v0;
      z = z0;
      while z >= 0
         v = v - delta*g;
         z = z + delta*v;
         y = [y  z];
      end
      v0 = c*v0;
   end

   % Simplified graphics

   close all
   figure
   plot(y)

%% Normal random number generator.

   figure
   hist(randn(100000,1),60)


%% Snapshot of two dimensional Brownian motion.

   figure
   m = 100;
   x = cumsum(randn(m,1));
   y = cumsum(randn(m,1));
   plot(x,y,'.-')
   s = 2*sqrt(m);
   axis([-s s -s s]);

%% Snapshot of three dimensional Brownian motion, brownian3

   n = 50;
   delta = 0.125;
   P = zeros(n,3);
   
   for t = 0:10000
      % Normally distributed random velocities.
      V = randn(n,3);
      % Update positions.
      P = P + delta*V;
   end

   figure
   plot3(P(:,1),P(:,2),P(:,3),'.')
   box on

%% Orbits, the n-body problem.

%{
% ORBITS  n-body gravitational attraction for n = 2, 3 or 9.
%   ORBITS(2), two bodies, classical elliptic orbits.
%   ORBITS(3), three bodies, artificial planar orbits.
%   ORBITS(9), nine bodies, the solar system with one sun and 8 planets.
%
%   ORBITS(n,false) turns off the uicontrols and generates a static plot.
%   ORBITS with no arguments is the same as ORBITS(9,true).

   % n = number of bodies.
   % P = n-by-3 array of position coordinates.
   % V = n-by-3 array of velocities
   % M = n-by-1 array of masses
   % H = graphics and user interface handles

   if (nargin < 2)
      gui = true;
   end
   if (nargin < 1);
      n = 9;
   end

   [P,V,M] = initialize_orbits(n);
   H = initialize_graphics(P,gui);

   steps = 20;     % Number of steps between plots
   t = 0;          % time

   while get(H.stop,'value') == 0

      % Obtain step size from slider.
      delta = get(H.speed,'value')/(20*steps);
      
      for k = 1:steps

         % Compute current gravitational forces.
         G = zeros(size(P));
         for i = 1:n
            for j = [1:i-1 i+1:n];
               r = P(j,:) - P(i,:);
               G(i,:) = G(i,:) + M(j)*r/norm(r)^3;
            end
         end
 
         % Update velocities using current gravitational forces.
         V = V + delta*G;
        
         % Update positions using updated velocities.
         P = P + delta*V;

      end

      t = t + steps*delta;
      H = update_plot(P,H,t,gui);
   end

   finalize_graphics(H,gui)
end 
%}

%% Run all three orbits, with 2, 3, and 9 bodies, and no gui.

   figure
   orbits(2,false)

   figure
   orbits(3,false)

   figure
   orbits(9,false)
