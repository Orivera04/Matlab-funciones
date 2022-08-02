function r = grade(M,n)
% grade(M,n): return the part of an object of a particular grade.
%  Return the part of M of grade n.
%  If n is omitted, return the grade of M (-1 if M is of mixed grade) 
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.
if nargin == 1
  if M.m(1) ~= 0
	if sum(abs(M.m(2:8))) == 0
		r = 0;
	else
		r = -1;
	end
  elseif sum(abs(M.m(2:4))) ~= 0
	if sum(abs(M.m(5:8))) == 0
		r = 1;
	else
		r = -1;
	end
  elseif sum(abs(M.m(5:7))) ~= 0
	if M.m(8) == 0
		r = 2;
	else
		r = -1;
	end
  elseif M.m(8) ~= 0
	r = 3;
  else
	r = -1;
  end
else
  if n==0
    if GAautoscalar
	r = M.m(1);
    else
	r = GA([M.m(1);0;0;0;0;0;0;0]);
    end
  elseif n==1
    r = GA([0;M.m(2);M.m(3);M.m(4);0;0;0;0]);
  elseif n==2
    r = GA([0;0;0;0;M.m(5);M.m(6);M.m(7);0]);
  elseif n==3
    r = GA([0;0;0;0;0;0;0;M.m(8)]);
  else
    if GAautoscalar
	r = 0;
    else
	r = GA(0);
    end
  end
end
