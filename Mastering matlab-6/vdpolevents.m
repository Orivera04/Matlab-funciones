function [value,isterminal,direction]=vdpolevents(t,y,mu)
%VDPOLEVENTS  van der Pol equation events.

value(1)=abs(y(2))-2; % find where |y(2)|=2
isterminal(1)=0;      % don't stop integration
direction(1)=0;       % don't care about crossing direction