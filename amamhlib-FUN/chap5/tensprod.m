function vrr=tensprod(v,x,y,z)
%
% vrr=tensprod(v,x,y,z)
% ~~~~~~~~~~~~~~~~~~~~
% This function forms the various components
% of v*R*R'. The calculation is vectorized
% over arrays of points
vxx=sum(sum(v.*x.*x)); vyy=sum(sum(v.*y.*y));
vzz=sum(sum(v.*z.*z)); vxy=sum(sum(v.*x.*y));
vxz=sum(sum(v.*x.*z)); vyz=sum(sum(v.*y.*z));
vrr=[vxx; vyy; vzz; vxy; vxz; vyz];