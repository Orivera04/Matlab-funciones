%Rotaciones y dilataciones
%theta: �ngulo de rotaci�n
%Lx: Dilataci�n en direcci�n del eje x
%Ly: Dilataci�n en direcci�n del eye y
    theta = 0;   % radians
    Lx=0.5;Ly=0.5;
    G = [cos(theta)+Lx -sin(theta); sin(theta) cos(theta)+Ly]
    %theta = 30  % degrees
    %G = [cosd(theta)+Lx -sind(theta); sind(theta) cosd(theta)+Ly]
    X=trian;
    subplot(1,2,1);
    dot2dot(X);
    title('Tri�ngulo original')
    axis([0 20 0 20])
    subplot(1,2,2);
    dot2dot(G*X);
    title('Tri�ngulo rotado 30�')
    axis([0 20 0 20])