function [u,z]=tempdif(theta,r)
%
% [u,z]=tempdif(theta,r)
% ~~~~~~~~~~~~~~~~~~~~~
% Difference between the steady state temp-
% erature and the initial temperature
u1=tempstdy(theta,r); [u2,z]=tempinit(theta,r);
u=u2-u1;