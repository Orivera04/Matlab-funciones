%
% This script illustrates the use of the Toeplitz routines.  First set 
% the size of the matrix.  Note that you can change this to see how
% the performance varies with n.  For small values of n, it may be faster
% to perform conventional matrix multiplication than to use the Toeplitz
% multiplication routine.  For larger values of n, toeplitzmult() is
% definitely faster.
%
% Note that CPU times can vary dramatically from one run of this script
% to the next.  In particular, fft() can be slow the first time it
% is used because of initialization of the FFTW library, but becomes 
% much faster thereafter.  Also, the CPU time for the fast multiplication 
% is sometimes smaller than the resolution of the system clock (typically 
% 0.01 seconds.)
%
% First, set the size of the matrix to use.  You can adjust this to see
% how the performance varies with n.
%
n=4096
%
% Next, construct a random vector x.
%
x=rand(n,1);
%
% Next, construct a random Toeplitz matrix of size n.
%
a=rand(n,1);
b=rand(1,n);
b(1)=a(1);
%
% Next, compute T from a and b.
%
t=cputime;
T=toeplitz(a,b);
fprintf(1,'CPU time to compute T from a and b was %f\n',cputime-t);
%
% Do the product by old fashioned matrix vector multiplication.
%
t=cputime;
yold=T*x;
fprintf(1,'CPU time for conventional multiplication was %f\n',cputime-t);
%
% Now, try the fast toeplitz multiplication
%
t=cputime;
ynew=toeplitzmult(a,b,x);
fprintf(1,'CPU time for fast multiplication was %f\n',cputime-t);
fprintf(1,'norm of difference between results was %e \n',norm(ynew-yold));
%
% Use toeplitzmultaux() to precompute F.
%
t=cputime;
F=toeplitzmultaux(a,b);
fprintf(1,'CPU time for precomputing F was %f\n',cputime-t);
%
% Use the precomputed F to speed up the multiplication.
%
t=cputime;
y2=toeplitzmult2(F,x);
fprintf(1,'CPU time for toeplitzmult2() was %f\n',cputime-t);
fprintf(1,'norm of difference between results was %e \n',norm(y2-yold));
