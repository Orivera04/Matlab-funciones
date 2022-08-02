function fouseris      
% Example: fouseris
% ~~~~~~~~~~~~~~~~~
% This program illustrates the convergence rate
% of Fourier series approximations derived by 
% applying the FFT to a general function which 
% may be specified either by piecewise linear 
% interpolation in a data table or by 
% analytical definition in a function given by 
% the user. The linear interpolation model 
% permits inclusion of jump discontinuities. 
% Series having varying numbers of terms can 
% be graphed to demonstrate Gibbs phenomenon 
% and to show how well the truncated Fourier 
% series represents the original function.  
% Provision is made to plot the Fourier series 
% of the original function or a smoothed 
% function derived by averaging the original 
% function over an arbitrary fraction of the 
% total period. 
%
% User m functions required: 
%    fousum, lintrp, inputv, sine 

% The following parameters control the number 
% of fft points used and the number of points 
% used for graphing.
nft=1024; ngph=1001; nmax=int2str(nft/2-1);

fprintf('\nFOURIER SERIES EXPANSION FOR');
fprintf(' A PIECEWISE LINEAR OR');
fprintf('\n        ANALYTICALLY DEFINED ');
fprintf('FUNCTION\n');

fprintf('\nInput the period of the function\n');
period=input('? > ');
xfc=(period/nft)*(0:nft-1)';
fprintf('\nHow many points define the function');
fprintf('\nby piecewise linear interpolation?');
fprintf('\n(Give a zero for analytical definition)\n')
nd=input('> ? ');
if nd > 0, xd=zeros(nd,1); yd=xd;
  fprintf('\nInput the x,y values one ');
  fprintf('pair per line\n');
  for j=1:nd 
    [xd(j),yd(j)]=inputv('> ? '); 
  end

% Use nft interpolated data points to 
% compute the fft
  yfc=lintrp(xd,yd,xfc); c=fft(yfc);
else
  fprintf('\nSelect the method for ');
  fprintf('analytical function definition:\n');
  fprintf('\n1 <=> Use an existing function ');
  fprintf('with syntax of the form:');
  fprintf('\nfunction y=funct(x,period), or \n');
  fprintf(['\n2 <=> Give a character string ',...
           'in argument x and period p.'])
  fprintf(['\n(Such as: sign(sin(2*pi*x/p)) '...
           'to make a square wave)\n'])
  nopt=input('Enter 1 or 2 ? > ');
  if nopt == 1
    fprintf('\nEnter the name of your ');
    fprintf('function\n');
    fnam=input('> ? ','s');
    yfc=feval(fnam,xfc,period); c=fft(yfc);
  else
    fprintf('\nInput the one-line definition');
    fprintf(' in terms of x and p\n');
    strng=input('> ? ','s');
    x=xfc; p=period; 
    yfc=eval(strng); c=fft(yfc);
  end
end

while 1
  fprintf('\nTo plot the series input xmin,');
  fprintf(' xmax, and the highest');
  fprintf(['\nharmonic not exceeding ', ...
          nmax,' (press [Enter] to stop)']);
  fprintf('\n(Use a negative harmonic number');
  fprintf(' to save your graph)\n');
  [xl,xu,nh]=inputv('> ? '); 
  if isnan(xl), break; end
  pltsav=(nh < 0); nh=abs(nh); 
  xtmp=xl+((xu-xl)/ngph)*(0:ngph);
  fprintf('\nTo plot the series smoothed ');
  fprintf('over a fraction of the');
  fprintf('\nperiod, input the smoothing ');
  fprintf('fraction');
  fprintf('\n(give 0.0 for no smoothing).\n');
  alpha=input('> ? ');
  yfou=fousum(c,xtmp,period,nh,alpha);
  xxtmp=xtmp; idneg=find(xtmp<0); 
  xng=abs(xtmp(idneg));
  xxtmp(idneg)=xxtmp(idneg)+ ...
               period*ceil(xng/period);
  if nd>0
    yexac=lintrp(xd,yd,rem(xxtmp,period));
  else
    if nopt == 1
      yexac=feval(fnam,xtmp,period);
    else
      x=xxtmp; yexac=eval(strng);
    end
  end
  in=int2str(nh);
  if alpha == 0
    titl=['Fourier Series for Harmonics ' ...
          'up to Order ',in];
  else
    titl=['Smoothed Fourier Series for ' ...
          'Harmonics up to Order ',in];
  end
  close; plot(xtmp,yfou,'-',xtmp,yexac,'--'); 
  ylabel('y axis'); xlabel('x axis'); zoom on
  title(titl); grid on; figure(gcf); disp(' ');
  disp('You can zoom in with the mouse button.')
  input('You can press [Enter] to continue. ','s');
  if pltsav
    disp(' ')
    filnam=input(['Give a file name to ' ...
           'save the current graph > ? '],'s');
    if length(filnam) > 0 
      eval(['print -deps ',filnam]); 
    end
  end
end

%=============================================

function y=sine(x,period)
% y=sine(x,period) 
% ~~~~~~~~~~~~~~~~
% Function for all or part of a sine wave.
%   x,period -  vector argument and period
%   y        - function value
%
y=sin(rem(x,period));

%=============================================

function yreal=fousum(c,x,period,k,alpha)
%
% yreal = fousum(c,x,period,k,alpha)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Sum the Fourier series of a real 
% valued function.
%
%   x      - The vector of real values at 
%            which the series is evaluated.
%   c      - A vector of length n containing 
%            Fourier coefficients output by 
%            the fft function
%   period - The period of the function
%   k      - The highest harmonic used in 
%            the Fourier sum.  This must 
%            not exceed n/2-1
%   alpha  - If this parameter is nonzero, 
%            the Fourier coefficients are 
%            replaced by those of a function 
%            obtained by averaging the 
%            original function over alpha 
%            times the period
%   yreal  - The real valued Fourier sum 
%            for argument x
%
% The Fourier coefficients c must have been 
% computed using the fft function which 
% transforms the vector [y(1),...,y(n)] into 
% an array of complex Fourier coefficients 
% which have been multiplied by n and are 
% arranged in the order:
%
%   [c(0),c(1),...,c(n/2-1),c(n/2),
%                  c(-n/2+1),...,c(-1)].
%
% The coefficient c(n/2) cannot be used 
% since it is actually the sum of c(n/2) and 
% c(-n/2). For a particular value of n, the 
% highest usable harmonic is n/2-1.
%
% User m functions called:  none
%----------------------------------------------

x=x(:); n=length(c); 
if nargin <4, k=n/2-1; alpha=0; end
if nargin <5, alpha=0; end
if nargin <3, period=2*pi; end
L=period/2; k=min(k,n/2-1); th=(pi/L)*x;
i=sqrt(-1); z=exp(i*th); 
y=c(k+1)*ones(size(th)); pa=pi*alpha;
if alpha > 0
  jj=(1:k)'; 
  c(jj+1)=c(jj+1).*sin(jj*pa)./(jj*pa);
end
for j=k:-1:2, y=c(j)+y.*z; end 
yreal=real(c(1)+2*y.*z)/n;

%=============================================

% function y=lintrp(xd,yd,x)
% See Appendix B

%=============================================

% function varargout=inputv(prompt)
% See Appendix B