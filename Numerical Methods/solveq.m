function [r1,r2,im1,im2]=solveq(u,v,n,a);
% Solves x^2 + ux + v = 0 (n = 1) or x + a(1) = 0 (n = 1).
%
% Example call: [r1,r2,im1,im2]=solveq(u,v,n,a)
% r1, r2 are real parts of the roots, 
% im1, im2 are the imaginary parts of the roots.
% Called by function bairstow.
%
if n==1
  r1=-a(1);im1=0;
else
  d=u*u-4*v;
  if d<0
    d=-d;
    im1=sqrt(d)/2; r1=-u/2; r2=r1; im2=-im1;
  elseif d>0
    r1=(-u+sqrt(d))/2; im1=0; r2=(-u-sqrt(d))/2; im2=0;
  else
    r1=-u/2; im1=0; r2=-u/2; im2=0;
  end;
end;
