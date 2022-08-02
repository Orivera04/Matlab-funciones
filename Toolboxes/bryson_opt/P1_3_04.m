% Script p1_3_04.m; min distance between 2 lines in 3D;  5/98, 3/20/02
%
A1=[1 2 3; 1 -1 2]; A2=[3 2 1; 2 -1 1]; b1=[10 10]'; b2=[3 -4]';
%
% Using the analytical solution:
C1=A1'*((A1*A1')\A1); C2=A2'*((A2*A2')\A2); d1=A1'*((A1*A1')\b1);
d2=A2'*((A2*A2')\b2); D1=C1+C2-C1*C2; D2=C1+C2-C2*C1;
x1=(D1\(d1+d2-C1*d2))', x2=(D2\(d1+d2-C2*d1))' 
%
% Using FMINCON:
p0=zeros(6,1); optn=optimset('MaxIter',100);
p=fmincon('mindist_f',p0,[],[],[],[],[],[],'mindist_c',optn);
x1=p(1:3)', x2=p(4:6)'

