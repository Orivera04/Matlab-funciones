function plotfrsp(vmat,out,in)
%PLOTFRSP Plot the frequency response generated by MOD2FRSP as a Bode plot.
%	plotfrsp(vmat)
%  	plotfrsp(vmat,out,in)
% PLOTFRSP generates Bode plots of the elements of the frequency dependent
% matrix, say F(w), whose sampled values are contained in the VARYING matrix
% vmat. The optional arguments OUT and IN  are row vectors of row and
% column indices respectively, and may be used to obtain the Bode plots of
% only the elements of the corresponding submatrix of F(w).
%
% See also MOD2FRSP.

%       Copyright 1994-2003 The MathWorks, Inc.
%       $Revision: 1.1.6.2 $

if nargin==0
    disp('Usage : plotfrsp(vmat,out,in)')
    return
end
[a b]=size(vmat);
if ( vmat(a,b)~=inf)
    error('The input VMAT needs to be a varying matrix')
end
N=vmat(a,b-1);
m=(a-1)/N;
n=(b-1);
if nargin==1
    out=1:m;
    in=1:n;
elseif nargin==2
    in=1:n;
end

[c d]=size(out);
[e f]=size(in);
if (c~=1 | e~=1)
   error('OUT and IN must be row vectors')
end

for i=out
   if (i>m | i<1)
      error('Entries of OUT are not in valid range')
   end
end
for i=in
   if (i>n | i<1)
      error('Entries of IN are not in valid range')
   end
end

y=vmat([1:N],b);
X=[];
for i=out
    for j=in
        z=[];
        for k=1:N
            z=[z;vmat((k-1)*m+i,j)];
        end
        X=[X,z];
    end
end
mag=abs(X);
phase=unwrap(angle(X))/pi*180;
clf
subplot(211)
loglog(y,mag);
xlabel('Frequency (radians/time)');
ylabel('Log Magnitude');
title('BODE PLOTS');
subplot(212)
semilogx(y,phase);
xlabel('Frequency (radians/time)');
ylabel('Phase (degrees)');