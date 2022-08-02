function F=setcorners(F)
%SETCORNERS  Function used by plot.
%   Function to make command slice work correctly.

% Copyright (c) 2001-04-22, B. Rasmus Anthin

[Ny Nx Nz]=size(F);
eps=realmin*100;
if ~F(1,1,1)
   F(1,1,1)=-eps;
else
   F(1,1,1)=F(1,1,1)*(1-1e-5);
end

if Nz>0
   if ~F(1,1,2)
      F(1,1,2)=eps;
   else
      F(1,1,2)=F(1,1,2)*(1+1e-5);
   end
elseif Nx>0
   if ~F(1,2,1)
      F(1,2,1)=eps;
   else
      F(1,2,1)=F(1,2,1)*(1+1e-5);
   end
elseif Ny>0
   if ~F(2,1,1)
      F(2,1,1)=eps;
   else
      F(2,1,1)=F(2,1,1)*(1+1e-5);
   end
end