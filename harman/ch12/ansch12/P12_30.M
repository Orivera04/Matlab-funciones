% P12_30.M
% Compute the length of a parabolic cable length hung between 
%   span = distance between end points (in any length units)
%   height = total height of cable relative to its lowest point
%     (in same units as span)
%
%   The integrand is defined in function arclenf and
%     the result is L=2* int[sqrt(1+(kx)**2)] from o to span/2
global CINT
span=input('Input span  ')
s=span/2;	% half span for integration
height=input('Input height  ') 
CINT=(4*height^2)/(s^4);
L2=quad('arclenf',0,s)
L=2*L2
fprintf('The length of the cable is %6.2f length units\n',L)
%
% Version 5: Change global variable to all caps.
