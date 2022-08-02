function [z,kz] = mandelbrot_step(z,kz,z0,d)
% MANDELBROT_STEP  Take a single step of the Mandelbrot iteration.
% [z,kz] = mandelbrot_step(z,kz,z0,d)
   z = z.^2 + z0;
   j = (abs(z) < 2);
   kz(j) = d;
