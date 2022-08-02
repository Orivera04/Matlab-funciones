clear all
syms a b c d w y1 y2 y3 s1 s2 s3;
syms A B C D E E1 E2 E3 E4 S S2;
e1=a-y1; e2=a+b+c+d-y2;
e3=2*c+w*y1; e4=2*c+6*d+w*y2;
s=solve(e1,e2,e3,e4,a,b,c,d);
a=s.a; b=s.b; c=s.c; d=s.d;
s1=b; s2=b+2*c+3*d; 
%a,b,c,d

% syms A B C D E E1 E2 E3 E4 S S2;
E1=A-y2;
E2=A+B+C+D-y3;
E3=2*C+w*y2;
E4=2*C+6*D+w*y3;
S=solve(E1,E2,E3,E4,A,B,C,D);
A=S.A; B=S.B; C=S.C; D=S.D;
S2=B; 
v=s2-S2;
a,b,c,d,v