function draw(s,O,c)
% draw(s,O,c) - draw a multivector. 
%  s: the multivector to be drawn.
%  O: an offset by which to displace the multivector before drawing (optional)
%  c: a color in which to draw the multivector (optional).
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.
if nargin==1
  title(['scalar = ' num2str(s)]);
elseif nargin==2
  if isa(O,'char')
      title(['scalar = ' num2str(s)],'Color',O);
  else
      title(['scalar = ' num2str(s)]);
  end
elseif nargin==3
  title(['scalar = ' num2str(s)],'Color',c);
end
hold on;
