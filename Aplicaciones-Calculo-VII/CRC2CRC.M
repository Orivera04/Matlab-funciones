function [w0,r0,type]=crc2crc(c,z)
%
% [w0,r0,type]=crc2crc(c,z)
% ~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function determines the circle or 
% straight line into which a circle or straight
% line maps under a linear fractional 
% transformation.
%
% c    - coefficients defining a linear 
%        fractional transformation 
%          w=(c(1)*z+c(2))/(c(3)*z*c(4))
%        where c(2)*c(3)-c(1)*c(4) is nonzero    
% z    - a vector of three complex values 
%        lying on a circle or a straight line
%
% w0   - center of a circle in the w plane 
%        if type=1, or a point on a straight 
%        line if type=2
% r0   - radius of a circle in the w plane 
%        if type=1, or a point on a straight 
%        line if type=2
% type - equals 1 to denote a circle or 2 to 
%        denote a straight line in the w plane
%
% User m functions called:  none
%----------------------------------------------

% check for degenerate transformation
if c(2)*c(3)==c(1)*c(4)
  disp(['Degenerate transformation in ', ...
        'function crc2crc']);
  w0=[]; r0=[]; type=[]; return;
end

% evaluate the mapping of the z points
w=(c(1)*z(:)+c(2))./(c(3)*z(:)+c(4));

% check whether a point passes to infinity or
% the three z points define a straight line
k=find(w==inf); 
dt=det([real(w),imag(w),ones(3,1)]);
if ~isempty(k); w(k)=[]; end

% case for a straight line in the w plane 
% defined by two points on the line
if dt==0 | ~isempty(k)
  type=2; w0=w(1); r0=w(2);
% case for a circle in the w plane defined by 
% a center point and the circle radius 
else
  type =1; 
  v=[2*real(w),2*imag(w),ones(3,1)]\abs(w).^2;
  w0=v(1)+i*v(2); r0=sqrt(v(3)+abs(w0)^2);
end
