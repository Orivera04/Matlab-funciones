function varargout=fsformat(varargin)
%FSFORMAT Fourier Series Format Conversion. (MM)
% Fourier series are commonly represented in one of three formats:
% Trigonometric    f(t) = Ao + sum( An*cos(nwot) + Bn*sin(nwot) )
%                             n=1:inf
% Alternate Trig:  f(t) =      sum( Cn*cos(nwot + Tn) )
%                             n=0:inf
% Exponential:     f(t) =      sum( Kn*exp(jnwot) )
%                             n=-inf:inf
%
% FSFORMAT converts one Fourier series format into another based on
% the number of input and output arguments provided:
% [An,Bn,Ao]=FSFORMAT(Kn)      Exponential to Trigonometric
% [An,Bn,Ao]=FSFORMAT(Cn,Tn)   Alternate to Exponential
% [Cn,Tn]=FSFORMAT(Kn)         Exponential to Alternate
% [Cn,Tn]=FSFORMAT(An,Bn,Ao)   Trigonometric to Alternate
% Kn=FSFORMAT(Cn,Tn)           Alternate to Exponential
% Kn=FSFORMAT(An,Bn,Ao)        Trigonometric to Exponential
%
% An,Bn,Ao = vectors containing the Trig format coefficients shown above
% Cn,Tn = vectors containing the Alternate coefficients
%        Cn(1) = DC component, Cn(i) is (i-1)th harmonic amplitude
%        Tn(1) = 0, Tn(i) is (i-1)th harmonic angle in DEGREES
% Kn = vector containing Exponential coefficients as used in
%      Mastering MATLAB Toolbox functions.
%
% See also FSHELP

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 8/9/99
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin==1 & nargout==2 % exponential to alternate
   kn=varargin{1};
   N=fssize(kn);
   varargout{1}=[fsharm(kn,0) 2*abs(fsharm(kn,1:N))];
   varargout{2}=[0 angle(fsharm(kn,1:N))*180/pi];
elseif nargin==1 & nargout==3 % exponential to trig
   kn=varargin{1};
   N=fssize(kn);
   varargout{1}=2*real(fsharm(kn,1:N));
   varargout{2}=-2*imag(fsharm(kn,1:N));
   varargout{3}=fsharm(kn,0);
elseif nargin==2 & nargout==1 % alternate to exponential
   dc=varargin{1}(1);
   kn=varargin{1}(2:end)/2;
   tn=varargin{2}(2:end)*pi/180;
   tmp=kn.*exp(j*tn);
   varargout{1}=[conj(fliplr(tmp)) dc tmp]; 
elseif nargin==2 & nargout==3 % alternate to trig
   kn=fsformat(varargin{:});
   [varargout{1:3}]=fsformat(kn);
elseif nargin==3 & nargout==1 % trig to exponential
   kn=(varargin{1}-j*varargin{2})/2;
   varargout{1}=[conj(fliplr(kn)) varargin{3} kn];
elseif nargin==3 & nargout==2 % trig to alternate
   tmp=complex(varargin{1},varargin{2});
   varargout{1}=[varargin{3} abs(tmp)];
   varargout{2}=[0 -angle(tmp)*180/pi];
else
   error('Improper Number of Input or Output Arguments.')
end
