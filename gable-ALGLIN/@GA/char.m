function s = char(p)
%char(p): convert a GA object to a string.
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.
if isa(OFrame,'struct')
  s = charF(p,OFrame);
else
  pl = ' ';
  s = '    ';
  if p.m(1) ~= 0
    s = [s pl num2str(p.m(1))];
    pl = ' + ';
  end
  if p.m(2) ~= 0
    if p.m(2) == 1
      s = [s pl 'e1'];
    else
      s = [s pl num2str(p.m(2)) '*e1'];
    end
    pl = ' + ';
  end
  if p.m(3) ~= 0
    if p.m(3) == 1
      s = [s pl 'e2'];
    else
      s = [s pl num2str(p.m(3)) '*e2'];
    end
    pl = ' + ';
  end
  if p.m(4) ~= 0
    if p.m(4) == 1
      s = [s pl 'e3'];
    else
      s = [s pl num2str(p.m(4)) '*e3'];
    end
    pl = ' + ';
  end
  
  if p.m(5) ~= 0
    if p.m(5) == 1
      s = [s pl 'e1^e2'];
    else
      s = [s pl num2str(p.m(5)) '*e1^e2'];
    end
    pl = ' + ';
  end
  if p.m(6) ~= 0
    if p.m(6) == 1
      s = [s pl 'e2^e3'];
    else
      s = [s pl num2str(p.m(6)) '*e2^e3'];
    end
    pl = ' + ';
  end
  if p.m(7) ~= 0
    if p.m(7) == 1
      s = [s pl 'e3^e1'];
    else
      s = [s pl num2str(p.m(7)) '*e3^e1'];
    end
    pl = ' + ';
  end
  
  if p.m(8) ~= 0
    if p.m(8) == 1
      s = [s pl 'I3'];
    else
      s = [s pl num2str(p.m(8)) '*I3'];
    end
    pl = ' + ';
  end
  
  if strcmp(pl, ' ')
    s = '     0';
  end
end
