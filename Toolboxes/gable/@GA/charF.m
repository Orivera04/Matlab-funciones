function s = charF(m,f)
% charF: print multivector m relative to frame f
%
%See also gable, char, Frame.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.
L=f.m;
R=m.m;
p=L*R;
n1=f.b1;
n2=f.b2;
n3=f.b3;
pl = ' ';
s = '    ';
if p(1) ~= 0
  s = [s pl num2str(p(1))];
  pl = ' + ';
end
if p(2) ~= 0
  if p(2) == 1
    s = [s pl n1];
  else
    s = [s pl num2str(p(2)) '*' n1];
  end
  pl = ' + ';
end
if p(3) ~= 0
  if p(3) == 1
    s = [s pl n2];
  else
    s = [s pl num2str(p(3)) '*' n2];
  end
  pl = ' + ';
end
if p(4) ~= 0
  if p(4) == 1
    s = [s pl n3];
  else
    s = [s pl num2str(p(4)) '*' n3];
  end
  pl = ' + ';
end

if p(5) ~= 0
  if p(5) == 1
    s = [s pl n1 '^' n2];
  else
    s = [s pl num2str(p(5)) '*' n1 '^' n2];
  end
  pl = ' + ';
end
if p(6) ~= 0
  if p(6) == 1
    s = [s pl n2 '^' n3];
  else
    s = [s pl num2str(p(6)) '*' n2 '^' n3];
  end
  pl = ' + ';
end
if p(7) ~= 0
  if p(7) == 1
    s = [s pl n3 '^' n1];
  else
    s = [s pl num2str(p(7)) '*' n3 '^' n1];
  end
  pl = ' + ';
end

if p(8) ~= 0
  if p(8) == 1
    s = [s pl n1 '^' n2 '^' n3];
  else
    s = [s pl num2str(p(8)) '*' n1 '^' n2 '^' n3];
  end
  pl = ' + ';
end

if strcmp(pl, ' ')
  s = '     0';
end
