function yp = yprlot(t,y)
% © Molnarka Gy''oz''o 1998; program a Differencialegyenletek 
                           % megoldasa reszhez
yp(1)=-0.01*y(2)*y(1)+0.2*y(1);
yp(2)=-0.9*y(2) + 0.02*y(1)*y(2);
yp = [yp(1);yp(2)];