     disp('>> %	PAPPUS'' THEOREM');
     %	PAPPUS' THEOREM
     GAfigure; clc; %/
     disp('>> %	PAPPUS'' THEOREM');
     %	PAPPUS' THEOREM
     disp('>> %');
     %
     disp('>> % 	We use Pappus merely as an example doing geometry.');
     % 	We use Pappus merely as an example doing geometry.
     disp('>> %');
     %
     disp('>> %	Pappus'' theorem (actually from projective geometry):');
     %	Pappus' theorem (actually from projective geometry):
     disp('>> %	-- Specify two pairs of collinear points');
     %	-- Specify two pairs of collinear points
     disp('>> % 	-- Cross-connect the points and intersect corresponding lines.');
     % 	-- Cross-connect the points and intersect corresponding lines.
     disp('>> % 	-> The result is three collinear points.');
     % 	-> The result is three collinear points.
     disp('>> %');
     %
     disp('>> % Two points and a factor to determine collinear point:');
     % Two points and a factor to determine collinear point:
     global P1 P2 P3 Q1 Q2 Q3 H1 H2 H3 A1 A2 A3; %/
     clf;	%/
     e = e3;	%/
     P1 = e - e1; %/
     P2 = e  + e2/4; %/
     mu = 1.5; %/
     P3 = (1-mu)*P1 + mu*P2; %/
     Q1 = e - 3*e1/4 -e2; %/
     Q2 = e + e1/6 - 1.1*e2; %/
     nu = 1.5; %/
     Q3 = (1-nu)*Q1 + nu*Q2; %/
     maxx = max([inner(e1,P1),inner(e1,P2),inner(e1,P3), inner(e1,Q1),inner(e1,Q2),inner(e1,Q3)]); %/
     minx = min([inner(e1,P1),inner(e1,P2),inner(e1,P3), inner(e1,Q1),inner(e1,Q2),inner(e1,Q3)]); %/
     maxy = max([inner(e2,P1),inner(e2,P2),inner(e2,P3), inner(e2,Q1),inner(e2,Q2),inner(e2,Q3)]); %/
     miny = min([inner(e2,P1),inner(e2,P2),inner(e2,P3), inner(e2,Q1),inner(e2,Q2),inner(e2,Q3)]); %/
     disp('>> ');
     
     GAmouse = 1; %/
     disp('>> % 	First line');
     % 	First line
     DrawHomogeneous(e,P1,'n','r'); GAtext(1.1*P1,'P_1','r'); %/
     DrawHomogeneous(e,P2,'n','r'); GAtext(1.1*P2,'P_2','r'); %/
     DrawHomogeneous(e,P3,'n','r'); GAtext(1.1*P3,'P_3','r'); %/
     DrawPolyline({P1,P2,P3},'r'); %/
     axis off; %/
     GAview([0 90]); %/
     axis([minx maxx miny maxy 0 1]);  %/
     disp('>> % 	Next: second line');
     % 	Next: second line
     GAprompt; %/
     DrawHomogeneous(e,Q1,'n','m'); GAtext(1.1*Q1,'Q_1','m'); %/
     DrawHomogeneous(e,Q2,'n','m'); GAtext(1.1*Q2,'Q_2','m'); %/
     DrawHomogeneous(e,Q3,'n','m'); GAtext(1.1*Q3,'Q_3','m'); %/
     DrawPolyline({Q1,Q2,Q3},'m'); %/
     axis([minx maxx miny maxy 0 1]);  %/
     disp('>> % 	Next: intersect the connection lines');
     % 	Next: intersect the connection lines
     GAprompt; %/
     DrawPolyline({P1,Q2},'k'); %/
     DrawPolyline({P2,Q1},'k'); %/
     disp('>> H1 = meet(join(P1,Q2),join(P2,Q1));');
     H1 = meet(join(P1,Q2),join(P2,Q1));
     disp('>> A1 = H1/inner(H1,e3);');
     A1 = H1/inner(H1,e3);
     DrawHomogeneous(e3,A1,'n','g'); GAtext(1.1*A1,'A_1','b'); %/
     axis([minx maxx miny maxy 0 1]);  %/
     GAprompt; %/
     DrawPolyline({P3,Q2},'k'); %/
     DrawPolyline({P2,Q3},'k'); %/
     H2 = meet(join(P2,Q3),join(P3,Q2)); %/
     A2 = H2/inner(H2,e3); %/
     DrawHomogeneous(e3,A2,'n','g'); GAtext(1.1*A2,'A_2','b'); %/
     axis([minx maxx miny maxy 0 1]);  %/
     GAprompt; %/
     DrawPolyline({P1,Q3},'k'); %/
     DrawPolyline({P3,Q1},'k'); %/
     H3 = meet(join(P1,Q3),join(P3,Q1)); %/
     A3 = H3/inner(H3,e3); %/
     DrawHomogeneous(e3,A3,'n','g'); GAtext(1.1*A3,'A_3','b'); %/
     axis([minx maxx miny maxy 0 1]);  %/
     GAprompt; %/
     DrawPolyline({A1,A2},'b') %/
     axis([minx maxx miny maxy 0 1]);  %/
     disp('>> % 	Next: check whether A1, A2, A3 are on a line:');
     % 	Next: check whether A1, A2, A3 are on a line:
     GAprompt; %/
     error = grade( A1^A2^A3/I3, 0); %/
     title(['A_1 \wedge A_2 \wedge A_3 = ' num2str(error) ' * I_3'],'Color','b'); %/
     GAmouse =0; %/
