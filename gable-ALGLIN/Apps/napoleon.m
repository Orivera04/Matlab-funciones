function napoleon(T)
% napolean(T) - illustrate Napoleon's theorem
%  T - a triple of homogeneous (in e3) vertices
%
% Examples: napoleon({e3,e3+e1,e3+2*e2})
%           napoleon({e3,e3+2*e1+.5*e2,e3+e1+2*e2})
%           napoleon({e3,e3+1.8*e1+1.8*e2,e3+e1+2*e2})

P1 = T{1};
P2 = T{2};
P3 = T{3};

i = e1^e2;
RR = gexp(i*2*pi/3);
S12 = (P1-P2)*RR+P1;
S23 = (P2-P3)*RR+P2;
S31 = (P3-P1)*RR+P3;

DrawPolyline({P1,P2,P3,P1},'k');
DrawPolyline({P1,S12,P2}, 'b');
DrawPolyline({P2,S23,P3}, 'b');
DrawPolyline({P3,S31,P1}, 'b');
C1 = (P1+S12+P2)/3;
C2 = (P2+S23+P3)/3;
C3 = (P3+S31+P1)/3;
DrawPolyline({C1,C2,C3,C1},'r');
GAview([0,90]);
