function arrow(A,O,c)
% arrowO(A,O,c): draw an arrow representing vector A in color c offset by O
%  The c argument is optional; if not given, draw a blue arrow.
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.

  if nargin == 2
     c = 'b';
  end
	if isavector(A)==0
	   error('Can only draw arrow for vector');
	end
	plot3([O.m(2) A.m(2)+O.m(2)], [O.m(3) A.m(3)+O.m(3)], [O.m(4) A.m(4)+O.m(4)], c);
  oldhold = ishold;
  hold on;
	% Construct a vector perpendicular to A
	lA = sqrt(inner(A,A));
	% Numerical problems require us to extra vector portion
	if abs(A.m(4)) < lA*.9
	   p1 = grade((e3^A)*inverse(A),1);
	else
	   p1 = grade((e2^A)*inverse(A),1);
	end
	hold on
	p2 = dual(p1^A);
	lS = lA*.9;
	p1 = (0.04*lS/sqrt(double(inner(p1,p1))))*p1;
	p2 = (0.04*lS/sqrt(double(inner(p2,p2))))*p2;
	pA = A/lA*lS;
	% Cell array version
	t = (0:pi/4:2*pi);
	head = cell(2,length(t));
	% Pre-add to reduce the cost below
	pAO = pA+O;
	AO = A+O;
	for i=1:length(t)
	    % Work with matrices to avoid GAExpand calls
	    head{1,i} = GA(sin(t(i))*p1.m + cos(t(i))*p2.m + pAO.m);
	    head{2,i} = AO;
%	    body{1,i} = 0.6*sin(t(i))*p1+0.6*cos(t(i))*p2 + O;
%	    body{2,i} = 0.6*sin(t(i))*p1+0.6*cos(t(i))*p2 +pA + O;
	end

%	GASurf(body);
	GALineMesh(head,c);
  if oldhold == 0
     hold off;
  end
