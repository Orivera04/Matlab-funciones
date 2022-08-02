function GAPatch(pts,c)
%GAPatch(pts,c): Draw a patch in color c (optional)
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.
  if nargin == 1
    c = 'y';
  end
% Convert character color to RGB triple
if isa(c,'char')
   if strncmp(c,'r',1)
      c = [1 0 0];
   elseif strncmp(c,'g',1)
      c = [0 1 0];
   elseif strncmp(c,'b',1)
      c = [0 0 1];
   elseif strncmp(c,'c',1)
      c = [0 1 1];
   elseif strncmp(c,'m',1)
      c = [1 0 1];
   elseif strncmp(c,'y',1)
      c = [1 1 0];
   elseif strncmp(c,'w',1)
      c = [1 1 1];
   end
end
  for i=1:length(pts)
     p = pts{i};
     x(i)=p.m(2);
     y(i)=p.m(3);
     z(i)=p.m(4);
  end
  patch(x,y,z,c);
