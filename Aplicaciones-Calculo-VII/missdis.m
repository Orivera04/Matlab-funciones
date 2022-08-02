function [dsq,x,y]=missdis(angle)
%
% [dsq,x,y]=missdis(angle)
% ~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function is used by fminbnd. It returns
% an error measure indicating how much the 
% target is missed for a particular initial 
% inclination angle of the projectile.
%
% angle - the initial inclination angle of
%         the projectile in degrees
%
% dsq   - the square of the difference between
%         Yfinal and the final value of y found
%         using function traject.
% x,y   - points on the trajectory. 
%
% Several global parameters (Vinit, Gravty, 
% Cdrag, Xfinl) are passed to missdis by the 
% driver program runtraj.
% 
% User m functions called: traject
%----------------------------------------------

global Vinit Gravty Cdrag Xfinl Yfinl 
[y,x,t]=traject ...
        (angle,Vinit,Gravty,Cdrag,Xfinl,1);
dsq=(y(length(y))-Yfinl)^2;