function b = GAisa(G, t)
%GAisa(G,t): Return 1 if G is of type t, 0 otherwise
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.
m = G.m ~= 0;
if sum(abs(m)) == 0
  b = 1;
elseif strcmp(t,'double') 
  if sum(m(2:8)) == 0
    b = 1;
  else
    b = 0;
  end
elseif strcmp(t,'vector') 
  if sum(m(5:8)) == 0 & G.m(1)==0
    b = 1;
  else
    b = 0;
  end
elseif strcmp(t,'bivector') 
  if sum(m(1:4)) == 0 & G.m(8)==0
    b = 1;
  else
    b = 0;
  end
elseif strcmp(t,'trivector') 
  if sum(m(1:7)) == 0
    b = 1;
  else
    b = 0;
  end
elseif strcmp(t,'multivector')
  if sum( [sum(m(1)) sum(m(2:4)) sum(m(5:7)) m(8)] ~= 0) > 1
    b = 1; 
  else
    b = 0;
  end
else
  b = 0; % I don't know what they asked for, but it's not us
end
