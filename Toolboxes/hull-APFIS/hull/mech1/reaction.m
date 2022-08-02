function [force,moment]=reaction(vectors,coords,couples)
%REACTION Finds the reaction force and moment needed to balance a force.
%   [FORCE,MOMENT]=REACTION(AF,[X Y], COUPLES) Given an Applied Force matrix
%   in standard multi vector format and the coordinates of the unknown 
%   reaction force, the routine will return the reaction force and moment 
%   at that point. If no couple is specified, it defaults to zero.
%   
%   See also ONEVECTOR, SUMFORCE, SUMMOMENT, THREEVECTOR, TWOVECTOR.

%   Details are to be found in Mastering Mechanics I, Douglas W. Hull,
%   Prentice Hall, 1998

%   Douglas W. Hull, 1998
%   Copyright (c) 1998-99 by Prentice Hall
%   Version 1.00

if nargin==2 % if couples not given 
  couples=0; % couples default to zero
end; 

[force,unusedcouple]=sumforce(vectors); % find sumation of vectors
moment=-(sum(couples)+summoment(vectors,coords)); % find sum of moments
force=-force; % since it is a reaction force must be negated
force(3)=coords(1); % move vector to proper spot
force(4)=coords(2); % move vector to proper spot
