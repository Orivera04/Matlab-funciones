function isinter=interior5(P,P1,P2,P3);
%Verifica si el pto. P es interior al tri�ngulo P1P2P3 o no.
x1=P1(1);y1=P1(2);x2=P2(1);y2=P2(2);x3=P3(1);y3=P3(2);x=P(1);y=P(2);
Area_PP1P2 = 1/2. *abs(det([x y 1;x1 y1 1;x2 y2 1]));
Area_PP2P3 = 1/2. *abs(det([x y 1;x2 y2 1;x3 y3 1]));
Area_PP3P1 = 1/2. *abs(det([x y 1;x3 y3 1;x1 y1 1]));
Area_P1P2P3 = 1/2. *abs(det([x1 y1 1;x2 y2 1;x3 y3 1]));
Sum=(Area_PP1P2 + Area_PP2P3 + Area_PP3P1);
isinter=isequal(Sum, Area_P1P2P3);

