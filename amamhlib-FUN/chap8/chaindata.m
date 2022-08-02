function [n,tmax,nt,fixorfree,rend,omega,...
                            cdamp]=chaindata
%                        
% [n,tmax,nt,fixorfree,rend,omega,...
%                           cdamp]=chaindata
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This example function creates data defining
% the chain. The function can be renamed and 
% modified to handle different problems.

n=8;          % Number or point masses
tmax=20;      % Maximum time for the solution
nt=401;       % Number of time values from 0 to tmax
fixorfree=0;  % Determines whether the right end 
              % position is controlled or free. Use
              % zero for free or one for controlled.
rend=0.05;    % Amplitude factor for end motion. This
              % can be zero if the ends are fixed.
omega=6;      % Frequency at which the ends are 
              %rotated.
cdamp=1;      % Coefficient regulating the amount of
              % viscous damping. Reduce cdamp to give
              % less damping.