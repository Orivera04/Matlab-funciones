function r=morley(T)
% morley(T) - illustrate Morley's theorem
%  T - a triple of homogeneous (in e3) vertices
%  r - an array with angles of Morley's triangle (should be 60,60,60)
%
% Examples: morley({e3,e3+2*e1+.5*e2,e3+e1+2*e2})
%           morley({e3,e3+5*e1+.1*e2,e3+2.5*e1+e2})
%           morley({e3,e3+1.8*e1+1.8*e2,e3+e1+2*e2})

P1 = T{1};
P2 = T{2};
P3 = T{3};
DrawPolyline({P1,P2,P3,P1},'k');
GAview([0,90]);

i = e1^e2;
R1 = (P3-P1)*(P2-P1);
R13 = gexp(sLog(R1)/3);
R2 = (P1-P2)*(P3-P2);
R23 = gexp(sLog(R2)/3);
R3 = (P2-P3)*(P1-P3);
R33 = gexp(sLog(R3)/3);

L12 = P1^(R13*(P2-P1));
L13 = P1^((P3-P1)*R13);
L23 = P2^(R23*(P3-P2));
L21 = P2^((P1-P2)*R23);
L31 = P3^(R33*(P1-P3));
L32 = P3^((P2-P3)*R33);

H1 = meet(L12,L21);
C1 = H1/inner(H1,e3);
DrawHomogeneous(e3,H1,'n','y')

H2 = meet(L23,L32);
C2 = H2/inner(H2,e3);
DrawHomogeneous(e3,H2,'n','y')

H3 = meet(L31,L13);
C3 = H3/inner(H3,e3);
DrawHomogeneous(e3,H3,'n','y')

DrawPolyline({P1,C1,P2},'g')
DrawPolyline({P2,C2,P3},'g')
DrawPolyline({P3,C3,P1},'g')
DrawPolyline({C1,C2,C3,C1},'r')
r = [inner(C2-C1,C3-C1)/norm(C3-C1)/norm(C2-C1), inner(C3-C2,C1-C2)/norm(C1-C2)/norm(C3-C2), inner(C1-C3,C2-C3)/norm(C2-C3)/norm(C1-C2)];
r = acos(r)*180/pi;
