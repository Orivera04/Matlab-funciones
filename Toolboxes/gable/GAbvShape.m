function v = GAbvShape(nv,x,y)
% GAbvShape(nv,x,y): Set the shape of the bivector for drawing.
% If called with no arguments, will return the current shape.
% nv may be 'default' (a disk)
%           'American'
%           'Canadian'
%           'Dutch'
%        or 'UserDefined'
% If nv is 'UserDefined', you should also pass in x and y coordinates
%  of the shape you wish to use.
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.

persistent t;
global GABVX GABVY;
  if nargin == 0
    if isa(t,'double')
      t = 'default';
    end
  else
    t = nv;
  end
  if nargin==3
    GABVX=x;
    GABVY=y;
  end
  v = t;
  
