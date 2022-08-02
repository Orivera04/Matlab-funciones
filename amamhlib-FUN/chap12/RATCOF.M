function [a,b]=ratcof(xdata,ydata,ntop,nbot)
%
% [a,b]=ratcof(xdata,ydata,ntop,nbot)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% Determine a and b to approximate ydata as 
% a rational function of the variable xdata. 
% The function has the form:
%
%    y(x) = sum(1=>ntop) ( a(j)*x^(j-1) ) /
%         ( 1 + sum(1=>nbot) ( b(j)*x^(j)) )
%
% xdata,ydata - input data vectors (real or 
%               complex)
% ntop,nbot   - number of series terms used in 
%               the numerator and the 
%               denominator.
%
% User m functions called: none
%----------------------------------------------

ydata=ydata(:); xdata=xdata(:); 
m=length(ydata);
if nargin==3, nbot=ntop; end;
x=ones(m,ntop+nbot); x(:,ntop+1)=-ydata.*xdata;
for i=2:ntop, x(:,i)=xdata.*x(:,i-1); end
for i=2:nbot 
  x(:,i+ntop)=xdata.*x(:,i+ntop-1); 
end
ab=x\ydata; 
a=ab(1:ntop); b=ab(ntop+1:ntop+nbot);