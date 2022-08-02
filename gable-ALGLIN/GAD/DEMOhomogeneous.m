     disp('>> %	AFFINE (HOMOGENEOUS) REPRESENTATION');
     %	AFFINE (HOMOGENEOUS) REPRESENTATION
     GAfigure; clc; %/
     disp('>> %	AFFINE (HOMOGENEOUS) REPRESENTATION');
     %	AFFINE (HOMOGENEOUS) REPRESENTATION
     disp('>> %');
     %
     disp('>> % 	For 2-space representation of (e1,e2) plane,');
     % 	For 2-space representation of (e1,e2) plane,
     disp('>> %  	add 1 more dimension e.');
     %  	add 1 more dimension e.
     global e p P q Q plane u d M; %/
     clf; %/
     e=e3; %/
     size = 1; %/
     va = [-size size -size size 0 2]; %/
     plane = {e+size*(e1+e2),e+size*(e1-e2),e+size*(-e1-e2),e+size*(-e1+e2)}; %/
     disp('>> e = e3; ');
     e = e3; 
     I2 = e1^e2; %/
     draw(e,'k') %/
     GAview([120 5]); %/
     GAtext(e/2-0.1*e2,'e'); %/
     GAtext(1.1*e,'0','k'); %/
     axis off; %/
     DrawPolygon(plane,'w'); %/
     axis(va); %/
     GAprompt; %/
     disp('>> % A (weighted) point may be represented by a vector.');
     % A (weighted) point may be represented by a vector.
     disp('>> p = e1/3+e2/2;');
     p = e1/3+e2/2;
     draw(p,'b'); %/
     GAtext(0.5*p+0.1*e,'p','b'); %/
     axis(va); %/
     GAprompt; %/
     disp('>> P = e+p;             ');
     P = e+p;             
     DrawHomogeneous(e,P,'b','r'); %/
     GAtext(0.5*P + 0.1*unit(p),'P','b'); %/
     axis(va); %/
     GAprompt; %/
     disp('>> % 	We might as well denote label at the point in 2-space.');
     % 	We might as well denote label at the point in 2-space.
     GAtext(1.1*P,'P','r'); %/
     GAprompt; %/
     disp('>> % 	Tilting for a better view.');
     % 	Tilting for a better view.
     GAtilt(10,5); %/
     GAprompt; %/
     clf; %/
     e=e3; %/
     size = 1; %/
     plane = {e+size*(e1+e2),e+size*(e1-e2),e+size*(-e1-e2),e+size*(-e1+e2)}; %/
     draw(e,'k'); %/
     GAtext(1.1*e,'0'); %/
     axis off; %/
     GAview([120 15]); %/
     disp('>> p = e1/4+e2/2;');
     p = e1/4+e2/2;
     disp('>> q = 2*e2/3-e1/2;');
     q = 2*e2/3-e1/2;
     disp('>> P = e+p;');
     P = e+p;
     disp('>> Q = e+q;');
     Q = e+q;
     DrawPolygon(plane,'w'); %/
     DrawHomogeneous(e,P,'b','r'); %/
     GAtext(1.1*P,'P','r'); %/
     DrawHomogeneous(e,Q,'g','r'); %/
     GAtext(1.1*Q,'Q','r'); %/
     axis(va); %/
     GAprompt; %/
     disp('>> % 	The bivector formed by P and Q can be used');
     % 	The bivector formed by P and Q can be used
     disp('>> % 	to represent the line element from P to Q.');
     % 	to represent the line element from P to Q.
     fprintf(1,'>> P^Q  ');
     input('');
     P^Q %w
     DrawBivector(P,Q,'y'); %/
     GAtext(0.25*(P+Q)-0.1*unit((P^Q)/I3),'P \wedge Q'); %/
     DrawSimplex({P,Q},'n','r'); %/
     axis(va); %/
     GAprompt; %/
     disp('>> %	The bivector can be reshaped to P^(Q-P):');
     %	The bivector can be reshaped to P^(Q-P):
     DrawBivector(P,Q-P,'g'); %/
     draw(Q-P,'r'); %/
     GAtext((Q-P)/2-0.1*e,'Q-P','r'); %/
     axis(va); %/
     title('P \wedge Q = P \wedge (Q-P)','Color','r'); %/
     disp('>> %	A line element: characterized by 2 points, ');
     %	A line element: characterized by 2 points, 
     disp('>> %	or by point and direction.');
     %	or by point and direction.
     GAprompt; %/
     GAtilt(-20,5); %/
     GAtilt(20,7.5); %/
     disp('>> %	The projective split of the bivector');
     %	The projective split of the bivector
     disp('>> %	retrieves the line parameters.');
     %	retrieves the line parameters.
     disp('>> %');
     %
     disp('>> %	The tangent vector:');
     %	The tangent vector:
     GAprompt; %/
     disp('>> PQ = P^Q');
     PQ = P^Q
     fprintf(1,'>> u = inner(e,PQ)     ');
     input('');
     u = inner(e,PQ)    %w
     DrawBivector(e,u,'m'); %/
     perp = grade((e^u)/norm(e^u)/I3,1); %/
     GAtext( (e+u)/2 + 0.1*perp,'e \wedge u'); %/
     DrawSimplex({e,e+u},'n','m'); %/
     GAtext( u/2+1.05*e+0.05*perp,'u'); %/
     axis(va); %/
     GAprompt; %/
     disp('>> %	The moment:');
     %	The moment:
     fprintf(1,'>> M = inner(e,e^PQ)     ');
     input('');
     M = inner(e,e^PQ)    %w
     d = M/u;  %/
     DrawBivector(d,u,'m'); %/
     GAtext( (d+u)/2 + 0.05*grade((d^u)/norm(d^u)/I3,1),'M'); %/
     axis(va); %/
     GAprompt; %/
     disp('>> %	The perpendicular support vector:');
     %	The perpendicular support vector:
     fprintf(1,'>> d = M/u     ');
     input('');
     d = M/u    %w
     DrawSimplex({e,e+d},'n','m'); %/
     GAtext( d/2+1.05*e+0.05*unit(u),'d'); %/
     axis(va); %/
     GAprompt; %/
     GAtilt(70,5); %/
     disp('>> ');
     
