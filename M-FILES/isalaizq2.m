function izq = isalaizq2(P,AB)
%P=[P(1),P(2)].recta=[x1,y1,x2,y2].([x1,y1],[x2,y2] en la recta).
global izq
E=(P(1)-AB(1))*(AB(4)-AB(2))-(P(2)-AB(2))*(AB(3)-AB(1));
if E<0
    izq=1;
elseif E>0
    izq=0;
elseif E==0
    izq=2;
end
