function pappus(L1,L2)
% pappus(L1,L2): illustrate pappus' theorem.
%  L1: three colinear points
%  L2: three colinear points
% Cross-connect the points and intersect coresponding lines.
% The result is three colinear points.
%
% Note: points must be homogeneous with e3 as the special coordinate.
%
% Examples: 
%   pappus({e3+e1,e3+2*e1+.1*e2,e3+5*e1+.4*e2},{e3+e2,e3+2*e1+2*e2,e3+4*e1+3*e2})
%   pappus({e3,e3+e1,e3+4*e1},{e3+e1+e2,e3+3*e1+2*e2,e3+7*e1+4*e2})

P1 = L1{1};
P2 = L1{2};
P3 = L1{3};
Q1 = L2{1};
Q2 = L2{2};
Q3 = L2{3};

DrawPolyline(L1,'r');
DrawPolyline(L2,'r');
DrawPolyline({P1,Q2},'k');
DrawPolyline({P1,Q3},'k');
DrawPolyline({P2,Q1},'k');
DrawPolyline({P2,Q3},'k');
DrawPolyline({P3,Q1},'k');
DrawPolyline({P3,Q2},'k');

H1 = meet(join(P1,Q2),join(P2,Q1));
A1 = H1/inner(H1,e3);
H2 = meet(join(P2,Q3),join(P3,Q2));
A2 = H2/inner(H2,e3);
H3 = meet(join(P1,Q3),join(P3,Q1));
A3 = H3/inner(H3,e3);

DrawPolyline({A1,A2},'b')

DrawHomogeneous(e3,H1,'n','g');
DrawHomogeneous(e3,H2,'n','g');
DrawHomogeneous(e3,H3,'n','g');

GAview([0,90]);
