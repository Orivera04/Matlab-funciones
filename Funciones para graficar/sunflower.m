%% MODEL A SUNFLOWER WITH THE GOLDEN RATIO
% It is well-documented that the Golden Ratio is observed in the angular
% geometry of seeds in sunflowers, coneflowers and pinecones, as well as
% other plants and natural phenomena.
% (http://www.mcs.surrey.ac.uk/Personal/R.Knott/Fibonacci/fibnat.html)
% 
% However, little regard has been paid, it seems, to the distance of each
% seed from the center. When I looked at sunflowers and coneflowers, I
% noticed that the density of seeds is not uniform throughout. Seeds toward
% the center are smaller than the seeds near the edges, and thus, their
% density is greater.
% 
% This file makes a connection between the Golden Ratio and the seed
% distance from the center of the sunflower. This accounts for the growth
% of each seed over time, and provides a better model for seed location
% than linear distance from center.
% 
% AUTHOR: Joseph Kirk (c) 5/2006
% EMAIL: jdkirk630 at gmail dot com

%% THE GOLDEN RATIO (PHI)
%
% $$\phi = \frac{\sqrt{5}-1}{2}$$
%
phi = (sqrt(5)-1)/2;  % = 0.6180339887499

%% NUMBER OF SEEDS
n = 2618;

%% SEED DISTANCE FROM CENTER
% The seed distances are raised to the Golden Ratio power
%
% $$\rho_k = (k-1)^\phi$$
%
rho = (0:n-1).^phi;

%% SEED ANGLE
% A cirlce contains |2*pi| radians, so |2*pi*phi| cuts the circle by the
% Golden Ratio
%
% $$\theta_k = (k-1)*2\pi\phi$$
%
theta = (0:n-1)*2*pi*phi;

%% PLOT
polar(theta, rho, 'b.');
title([num2str(n) ' Sunflower Seeds']);
set(gcf, 'color', 'w');

