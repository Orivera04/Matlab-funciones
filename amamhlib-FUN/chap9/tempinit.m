function [u,z]=tempinit(theta,r)
%
% [u,z]=tempinit(theta,r)
% ~~~~~~~~~~~~~~~~~~~~~~
% Initial temperature varying parabolically
% with the radius
theta=theta(:); r=r(:)'; z=exp(i*theta)*r;
u=ones(length(theta),1)*(1-r.^2);