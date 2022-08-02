function disk(A,O,c)
%disk: draw a disk to represent bivector A offset by O in color c.
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.

     if isabivector(A) == 0
	error('Can only draw disk for bivector');
     end
 
     dA = dual(A);

     lA = abs(norm(dA));
     if abs(dA.m(4)) < lA*.9
        p1 = grade((e3^dA)*inverse(dA),1);
     else
        p1 = grade((e2^dA)*inverse(dA),1);
     end
     hold on
     p2 = dual(p1^dA);

     p1 = (sqrt(lA/pi)/sqrt(abs(double(inner(p1,p1)))))*p1;
     p2 = (sqrt(lA/pi)/sqrt(abs(double(inner(p2,p2)))))*p2;
     %p1 = (sqrt(lA/pi)/abs(norm(p1)))*p1; %Tim's first fix
     %p2 = (sqrt(lA/pi)/abs(norm(p2)))*p2;
     % Cell array version
     t = (0:pi/12:2*pi);
     for i=1:length(t)
	% Speed it up a little by using matrices directly
	pts{i} = GA(sin(t(i))*p1.m + cos(t(i))*p2.m +O.m);
     end

     GAPatch(pts,c);
     for i=1:4:length(t)-1
	p{1} = pts{i};
	p{2} = 1.1*(pts{i}-O) + dual((pts{i}-O)^dA)/abs(norm(dA))/4+O;
	DrawPolyline({p{2},p{1}},'k');
     end
