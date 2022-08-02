function [theta,w]=br_mapping(wp1,wp2)

%   usage   theta=br_mapping(wp1,wp2)
%
%   where   theta = values of theta (original filter)
%           w = mapped valued of omega (transformed filter)
%           wp1 = desired 1st passband cutoff in transformed filter
%           wp2 = desired 2nd passband cutoff in transformed filter
%       
%           all frequencies are in radians


w=0:.01:pi;
theta_p=abs(wp2-wp1);                          % set pass band frequency
a=cos((wp2+wp1)/2)/cos((wp2-wp1)/2);            % set constants
k=tan((wp2-wp1)/2)*tan(theta_p/2);

Z=(exp(-2*j*w)-2*a*exp(-j*w)/(k+1)+(1-k)/(k+1))./((1-k)*exp(-2*j*w)/(k+1)-2*a*exp(-j*w)/(k+1)+1);  % pg 434 from old Oppenheim & Schafer book
theta=abs(angle(Z));

