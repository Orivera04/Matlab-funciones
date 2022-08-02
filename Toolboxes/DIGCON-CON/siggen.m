function [sig]=siggen(C,ftime,T)
%SIGGEN	Signal generation (combinations of step, ramp, sinusoid).
%	[sig]=siggen(C,ftime,T) generates a signal matrix sig.  Each
%	row of sig is a function of time.   ftime is the duration in 
%	seconds of the signals, and T is the sampling interval.  C is a 
%	matrix that specifies the type of signals that are created. C has 
%	3 columns for every signal (that is, for every row of sig).
%       In a given row of C, each set of three numbers, `a b c', has the 
%	following meaning.  If b=0, the set of numbers  refers to a step 
%	signal of amplitude `a' starting at time `c'.  For example, to specify
%	a unit step signal starting at 2 seconds, set C=[1 0 2].
%	To specify a vector of two signals, the first of which is zero, 
%	and the second of which is a unit step starting at time 0, set
%       C=[0 0 0 1 0 0].  
%
%       If `b' is a negative number, the set of numbers `a b c' refers to 
%	a polynomial signal t^(-b) with amplitude `a' and start time `c'.  
%	For example, to generate a ramp signal with a slope of 2 starting 
%	at time 0 use [2 -1 0].
%
%       If `b' is a positive number, the set of numbers `a b c' refers to a 
%	sinusoid of amplitude `a', frequency `b' (radians per second), and 
%	starting phase `c' (radians).
%
%       If C has more than one row, the signals described  by each row are 
%	added together.  The time axis for plotting these signals is
%	t=[0:kf-1]*T.

%       R.J. Vaccaro 10/94

kf=ceil(ftime/T);
t1=[0:kf-1]*T;
[m,n]=size(C);
M=round(n/3);
if n~=3*M
  fprintf('\n Error in SIGGEN.M: The coefficient matrix must have \n')
  fprintf(' 3 columns for each element of the signal vector. \n\n')
  sig=[];return
end
sig=zeros(M,kf);
for j=1:M
for i=1:m
  if C(i,3*j-1) == 0
    f=round(C(i,3*j)/T);
    if f==0
        sig(j,:)=sig(j,:)+C(i,3*j-2)*ones(1,kf);
    elseif f>kf
        fprintf('Desired start time for step signal is larger than ftime')
        sig=[];return
    else
        sig(j,:)=sig(j,:)+[zeros(1,f) C(i,3*j-2)*ones(1,kf-f)];
    end
  elseif C(i,3*j-1) < 0;
    f=round(C(i,3*j)/T);
    if f==0
        sig(j,:)=sig(j,:)+C(i,3*j-2)*t1.^(-C(i,3*j-1));
    elseif f>kf
        fprintf('Desired start time for polynomial signal is larger than ftime')
        sig=[];return
    else
        sig(j,:)=sig(j,:)+[zeros(1,f+1) C(i,3*j-2)*([1:kf-f-1]*T).^(-C(i,3*j-1))];
   end
  else
      sig(j,:)=sig(j,:)+C(i,3*j-2)*sin(C(i,3*j-1)*t1+...
				C(i,3*j)*ones(1,kf));
  end
end
end
return
