% EX8_2.M Plot the Fourier series of the function f(t) 
%   f(t)=0  -pi < t < 0
%   f(t)=t   0  < t < pi
%
% Plot f(t) for 5 and 20 terms in the series
clear
t =[-pi:.031:pi];               % Time points for plotting
sizet=size(t);
fn = pi/4*(ones(sizet));        % Fourier approximation at each t
yplt=zeros(sizet);              %  for plot of f(t)
% 5 terms
for n=1:5
 fn=fn+ (1/pi)*(-2*cos((2*n-1)*t)/(2*n-1)^2)-((-1)^n*sin(n*t)/n); 
end					
%
for k=1:length(t)               % Create f(t) 
  if t(k) < 0 
   yplt(k)=0;
  else
   yplt(k)=t(k);
  end 
end
clf                             % Clear any figures 
subplot(2,1,1),plot(t,fn,t,yplt,'--');
xlabel('t')
ylabel('f(t)')
title('Fourier series approximation to f(t) - Figure 8.2')
legend(['N=',num2str(n)],'f(t)') % Annotate the graph
% Add 15 more terms
for n=6:20
 fn=fn+ (1/pi)*(-2*cos((2*n-1)*t)/(2*n-1)^2)-((-1)^n*sin(n*t)/n); 
end
subplot(2,1,2),plot(t,fn,t,yplt,'--');
xlabel('t')
ylabel('f(t)')
legend(['N=',num2str(n)],'f(t)')
%
% Modify the program to compute an arbitrary number of terms 
%  in the series (i.e. input n). Plot the graph for many terms 
%  and notice the overshoot at the ends of the interval no matter
%  how many terms are taken.
%    (This is explained in the text as the Gibbs phenomenon.)