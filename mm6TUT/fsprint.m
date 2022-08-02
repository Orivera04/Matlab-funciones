function s=fsprint(varargin)
%FSPRINT Fourier Series Pretty Print. (MM)
% FSPRINT(Kn) pretty prints a character array containing Fourier series data
% Kn formatted for easy viewing in the Command Window. The left column contains
% harmonic indices and the right column contain the Fourier series coefficients.
%
% FSPRINT(Kn,FORMAT) converts the Fourier series vector Kn to the format given
% by FORMAT, then displays the results. FORMAT must be one of the following strings:
%
% 'exp' prints the default exponential format:
%      f(t) =      sum( Kn*exp(jnwot) )
%            n=-inf:inf
%
% 'alt' prints the alternate trigonometric format
%      f(t) =      sum( Cn*cos(nwot + Tn) )
%               n=0:inf
% where Cn(1) is the DC component and Cn(k) is the (k-1)th harmonic
%
% 'trig' prints the trigonometric format
%      f(t) = Ao + sum( An*cos(nwot) + Bn*sin(nwot) )
%               n=1:inf
%
% C=FSPRINT(...) returns the formatted data in the character array C rather
% than displaying it in the Command window.
%
% See also FSHELP

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 9/14/01
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin<2
   form='exp';
elseif nargin>2
   error('One or Two Input Arguments Required.')
else
   form=varargin{2};
end
if ~ischar(form)
   error('FORMAT Argument Must be a String.')
end
Kn=varargin{1};
[N,msg]=fssize(Kn);
error(msg)
Kn=fsround(Kn);
switch lower(form)
case 'exp'
   n=-N:N;
   Nh=length(n);
   c=cell(Nh+1,1);
   c{1}='Harmonic   F.S. coefficient';
   for i=1:Nh
      if imag(Kn(i))==0
         c{i+1}=sprintf('%6d %10.3g',n(i),real(Kn(i)));
      elseif real(Kn(i))==0
         c{i+1}=sprintf('%6d           %10.3gi',n(i),imag(Kn(i)));
      else
         c{i+1}=sprintf('%6d %10.3g%10.3gi',n(i),real(Kn(i)),imag(Kn(i)));
      end
   end
case 'alt'
   [Cn,Tn]=fsformat(Kn);
   Nh=length(Cn);
   n=0:Nh-1;
   c=cell(Nh+1,1);
   c{1}='Harmonic  Amplitude      Angle';
   for i=1:Nh
      if Cn(i)==0 | Tn(i)==0
         c{i+1}=sprintf('%6d  %10.3g',n(i),Cn(i));
      else
         c{i+1}=sprintf('%6d  %10.3g %10.3g',n(i),Cn(i),Tn(i));
      end
   end
case 'trig'
   [An,Bn,Ao]=fsformat(Kn);
   Nh=length(An);
   n=1:Nh;
   c=cell(Nh+2,1);
   c{1}='Harmonic   Cosine         Sine';
   c{2}=sprintf('%6d %10.3g',0,Ao);
   for i=1:Nh
      c{i+2}=sprintf('%6d %10.3g   %10.3g',n(i),An(i),Bn(i));
   end
otherwise
   error('FORMAT Argument Unkown.')
end
if nargout==0
   disp(' ')
   loose=strcmp(get(0,'FormatSpacing'),'loose');
   if loose, disp(' '), end
   disp(char(c))
   if loose, disp(' '), end
else
   s=char(c);
end