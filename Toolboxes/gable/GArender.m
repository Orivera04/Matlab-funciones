function m = GArender(a)
% GArender(a): Query/set the Geometric Algebra rendering mode
%  With no arguments, this routine returns the rendering mode.
%  With one argument, this routine will set the rendering mode to
%  that argument
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.
persistent mode
if nargin==1
  mode = a;
elseif nargin==0 & length(mode)==0
  mode = 'zbuffer';
end
m = mode;
  
