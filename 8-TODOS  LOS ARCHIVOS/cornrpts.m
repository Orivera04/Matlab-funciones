function v=cornrpts(u,N)
% v=cornrpts(u,N)
% ~~~~~~~~~~~~~~
% This function generates approximately N
% points between min(u) and max(u) including 
% all points in u plus additional points evenly
% spaced in each successive interval.
% u   -  vector of points
% N   -  approximate number of output points
%        between min(u(:)) and max(u(:))
% v   -  vector of points in increasing order 

u=sort(u(:))'; np=length(u);
d=u(np)-u(1); v=u(1);
for j=1:np-1
  dj=u(j+1)-u(j); nj=max(1,fix(N*dj/d)); 
  v=[v,[u(j)+dj/nj*(1:nj)]];
end