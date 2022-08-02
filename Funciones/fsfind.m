function [Fn,f,t]=fsfind(F,T,N,M,P)
%FSFIND Find Fourier Series Approximation. (MM)
% Fn=FSFIND(FUN,T,N,M) computes the Complex Exponential Fourier Series
% of a real valued signal described by the function FUN which is an
% M-file function or function handle.
% The function is called as f=FUN(t) where t is a vector over 0<=t<=T.
%
% T is the period of the function. N is the number of harmonics.
% M is an optional padding number. N+M Fourier series harmonics
% are found and only N are retained. Since the FFT is used, in most
% cases, M>0 increases accuracy. If M is not given or is empty, M=N. 
%
% Fn=FSFIND(t,f,N,M) computes the Fourier Series of a signal tabulated
% in the vectors t and f, where f(i) is the function evaluated at t(i).
% t(1) must be zero and t(length(t)) is the signal period. Likewise,
% f(1) = f(length(f)) is required. Any number of data points >3 can be used.
% Intermediate points are found by linear interpolation.
%
% [Fn,f,t]=FSFIND(...) returns values of the function FUN
% in f evaluated at the points in t over the range 0<=t<=T.
%
% FSFIND(FUN,T,N,M,P) passes the data in P to the function FUN as
% f=FUN(t,P). This allows parameters to be passed to FUN.
%
% See also FSHELP

% Calls: mminterp

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 2/9/95, revised 5/2/96 8/16/96 10/10/96, v5: 1/14/97, v6: 3/07/01
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

ni=nargin;
if ni==3          M=N;
elseif isempty(M) M=N;
end
M=max(abs(M(1)),1);
n=2*(N+M);
if ischar(F)| isa(F,'function_handle')	% function given
   
   To=T;
   t=linspace(0,To,n+1);
   if ni<5   f=feval(F,t);
   else      f=feval(F,t,P);
   end
   
else        % function is tabulated (role of T and F are reversed!)
   
   if F(1)>0, error('First Time Point Must be 0.'),end
   if abs(T(1)-T(end))>1000*eps,
      error('First and Last Function Values Must be the Same.')
   end
   if length(F)~=length(T)
      error('t and f must be the same length.')
   end
   To=F(length(F)); % period of function
   t=linspace(0,To,n+1);
   f=mminterp(F,T,t);
end

Fn=fft(f(1:n));
Fn=Fn(1:N+1)/n;
Fn=[conj(Fn(N+1:-1:2)) Fn];
Fn(N+1)=real(Fn(N+1)); % DC term is real for real functions
