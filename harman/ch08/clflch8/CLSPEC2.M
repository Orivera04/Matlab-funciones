% CLSPEC2.M Plot the positive amplitude spectrum and the 
%  Fourier series representation for the pulse train with
%  A=1, period T=2*pi, and pulse width tau=pi/2. 
n=1:10;                         % Number of components
Wn=zeros(size(n));
Wn=2*(1/pi)*(sin(n*pi/4)./n);   % Frequency spectrum n=1,2,...
Wn=[1/4,Wn];                    % Add dc term	
n=[0,n];
%
t=[-3*pi:.02:3*pi];             % Range of t
f=zeros(size(t));
for k=1:1:20;                        % f(t) with 20 terms   
f=f+(2/(k*pi))*sin(k*pi/4)*cos(k*t); % in series
end
f=1/4+f;                        % Add dc value A*tau/T 
% Put in a zero line and plot frequency 
fzero=zeros(size(n)); 
clf                             % Clear any figures
subplot(2,1,1),plot(n,Wn,'*',n,fzero,'-');
xlabel('w radians per second')
ylabel('(2/pi)*sinc(n*pi/4)')
title('Fourier Series of Pulse Train - Figure 8.7')
% Plot f(t)
subplot(2,1,2),plot(t,f)
xlabel('t time in seconds')
ylabel('f(t)')
%
% A number of interesting experiments can be performed with the pulse
%  train including
%  a. vary the number of terms in the Fourier series (k) and observe f(t)
%  b. eliminate low frequency terms from the series and observe f(t)
%  c. vary the ratio tau/T and analyze the spectrum
%  d. annotate the graph with the parameter values (A, tau, T)


