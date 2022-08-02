function sinetrp      
% Example: sinetrp
% ~~~~~~~~~~~~~~~~~
% This example illustrates cubic spline 
% approximation of sin(x), its first two 
% derivatives, and its integral.
%
% User m functions required: 
%    splineg, splincof

% Create data points on the spline curve
xd=linspace(0,2*pi,21); yd=sin(xd); 

% Evaluate function values at a dense 
% set of points
x=linspace(-pi/2,5/2*pi,61); 
[y,b,c]=splineg(xd,yd,x,0); 
yp=splineg(xd,yd,x,1,[],b,c);
ypp=splineg(xd,yd,x,2,[],b,c); 
yint=splineg(xd,yd,x,3,[],b,c); 

% Plot results
z=x/pi; zd=xd/pi; close
plot(z,y,'k-',zd,yd,'ko',z,yp,'k:',...
    z,ypp,'k-.',z,yint,'k+'); 
title(['Spline Differentiation and ', ...
       'Integration of sin(x)']);
xlabel('x / pi'); ylabel('function values');
legend('y=sin(x)','data','y''(x)','y''''(x)', ...
       '\int y(x) dx',1); grid on
figure(gcf); pause;
% print -deps sinetrp

%==============================================

function [val,b,c]=splineg(xd,yd,x,deriv,endc,b,c)
%
% [val,b,c]=splineg(xd,yd,x,deriv,endc,b,c)  
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% For a cubic spline curve through data points
% xd,yd, this function evaluates y(x), y'(x),
% y''(x), or integral(y(x)*dx, xd(1) to x(j) )
% for j=1:length(x).The coefficients needed to
% evaluate the spline are also computed.
%
% xd,yd   - data vectors defining the cubic 
%           spline curve
% x       - vector of points where curve 
%           properties are computed. 
% deriv   - denoting the spline curve as y(x),
%           deriv=0 gives a vector for y(x)
%           deriv=1 gives a vector for y'(x)
%           deriv=2 gives a vector for y''(x)
%           deriv=3 gives a vector of values 
%              for integral(y(z)*dz) from xd(1)
%              to x(j) for j=1:length(x)
% endc    - endc=1 makes y'''(x) continuous at 
%           xd(2) and xd(end-1).
%           endc=[2,left_slope,right_slope]
%           imposes slope values at both ends.
%           endc=[3,left_slope] imposes the left
%           end slope and makes the discontinuity
%           of y''' at xd(end-1) small.
%           endc=[4,right_slope] imposes the right
%           end slope and makes the discontinuity
%           of y''' at xd(2) small.
% b,c       coefficients needed to perform the
%           spline interpolation. If these are not
%           given, function unmkpp is called to
%           generate them. 
% val       values y(x),y'(x),y''(x) or
%           integral(y(z)dz, z=xd(1)..x) for
%           deriv=0,1,2, or 3, respectively.

if nargin<5 | isempty(endc), endc=1; end
if nargin<7, [b,c]=splincof(xd,yd,endc); end
n=length(xd); [N,M]=size(c);

switch deriv	
    
case 0 % Function value
  val=ppval(mkpp(b,c),x); 
  
case 1 % First derivative
  C=[3*c(:,1),2*c(:,2),c(:,3)];
  val=ppval(mkpp(b,C),x); 
  
case 2 % Second derivative
  C=[6*c(:,1),2*c(:,2)];
  val=ppval(mkpp(b,C),x); 
  
case 3 % Integral values from xd(1) to x 
  k=M:-1:1;
  C=[c./k(ones(N,1),:),zeros(N,1)];
  dx=xd(2:n)-xd(1:n-1); s=zeros(n-2,1);
  for j=1:n-2, s(j)=polyval(C(j,:),dx(j)); end
  C(:,5)=[0;cumsum(s)]; val=ppval(mkpp(b,C),x);		
  
end

%==============================================

function [b,c]=splincof(xd,yd,endc)
%
% [b,c]=splincof(xd,yd,endc) 
% ~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function determines coefficients for
% cubic spline interpolation allowing four
% different types of end conditions.
% xd,yd - data vectors for the interpolation
% endc  - endc=1 makes y'''(x) continuous at 
%         xd(2) and xd(end-1).
%         endc=[2,left_slope,right_slope]
%         imposes slope values at both ends.
%         endc=[3,left_slope] imposes the left
%         end slope and makes the discontinuity
%         of y''' at xd(end-1) small.
%         endc=[4,right_slope] imposes the right
%         end slope and makes the discontinuity
%         of y''' at xd(2) small.
%           
if nargin<3, endc=1; end;
type=endc(1); xd=xd(:); yd=yd(:);

switch type
    
case 1
  % y'''(x) continuous at the xd(2) and xd(end-1)
  [b,c]=unmkpp(spline(xd,yd));
  
case 2  
  % Slope given at both ends
  [b,c]=unmkpp(spline(xd,[endc(2);yd;endc(3)]));
  
case 3
  % Slope at left end given. Compute right end
  % slope.
  [b,c]=unmkpp(spline(xd,yd));
  c=[3*c(:,1),2*c(:,2),c(:,3)];
  sright=ppval(mkpp(b,c),xd(end));
  [b,c]=unmkpp(spline(xd,[endc(2);yd;sright]));
  
case 4 
  % Slope at right end known. Compute left end
  % slope.
  [b,c]=unmkpp(spline(xd,yd));
  c=[3*c(:,1),2*c(:,2),c(:,3)];
  sleft=ppval(mkpp(b,c),xd(1));
  [b,c]=unmkpp(spline(xd,[sleft;yd;endc(2)]));    
  
end