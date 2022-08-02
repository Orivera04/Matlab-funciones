function [u,X,T,uf,t]=ustring(a,v,tmax,nt)
%
% [u,X,T,uf,t]=ustring(a,v,tmax,nt)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function computes the deflection u(x,t)
% of a semi-infinite string subjected to a 
% moving force. The equation for the normalized
% deflection is
% u(x,t)=1/a/(a^2-v^2)*((v-a-v*abs(x-a*t)...
%                           +a*abs(x-v*t));
% a    - speed of wave propagation in the string
% v    - speed of the force moving to the right 
% tmax - maximum time for computing the solution
% nt   - number of time increments computed
% uu   - array of displacement values normalized
%        by dividing by a factor equal to the force 
%        magnitude over twice the density per unit
%        length. Position varies column-wise and
%        time varies row-wise in the array.
% X,T  - position and time arrays for the solution
% uf   - deflection vector under the force
% t    - time vector for the solution (same as the
%        columns of T)
%       
t=linspace(0,tmax,nt)'; xmax=1.05*tmax*max(a,v);
u=zeros(nt,4); nx=4; X=zeros(nt,nx); X(:,nx)=xmax;
c=1/a/(a^2-v^2); xw=a*t; xf=v*t; T=repmat(t,1,4);
uw=c*xw*(v-a+abs(v-a)); uf=c*xf*(v-a-abs(v-a));
if a>v, X(:,2)=xf; X(:,3)=xw; u(:,2)=uf;
else, X(:,2)=xw; X(:,3)=xf; u(:,2)=uw; end