function [r,t,pbegin]=cabldefl(len,p)
%
% [r,t,pbegin]=cabldefl(len,p)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function computes the static equilibrium 
% position for a cable of rigid weightless 
% links having concentrated loads applied at 
% the joints and the outside of the last link. 
% The outside of the first link is positioned 
% at the origin.
%
% len    - a vector of link lengths 
%          len(1), ..., len(n)
% p      - a matrix with rows giving the 
%          force components acting at the 
%          interior joints and at the outer 
%          end of the last link
%
% r      - matrix having rows which give the 
%          final positions of each node
% t      - vector of member tensions
% pbegin - force acting at the outer end of 
%          the first link to achieve 
%          equilibrium 
%
% User m functions called:  none
%----------------------------------------------

n=length(len); len=len(:); nd=size(p,2);

% Compute the forces in the links
T=flipud(cumsum(flipud(p))); 
t=sqrt(sum((T.^2)')');

% Obtain the deflections of the outer ends 
% and the interior joints
r=cumsum(T./t(:,ones(1,nd)).*len(:,ones(1,nd)));
r=[zeros(1,nd);r]; pbegin=-t(1)*r(2,:)/len(1);