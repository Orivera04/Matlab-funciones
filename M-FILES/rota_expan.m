%Rotaciones y dilataciones
%theta: ángulo de rotación
%Lx: Dilatación en dirección del eje x
%Ly: Dilatación en dirección del eye y
    theta = 0;   % radians
    Lx=0.5;Ly=0.5;
    G = [cos(theta)+Lx -sin(theta); sin(theta) cos(theta)+Ly]
    %theta = 30  % degrees
    %G = [cosd(theta)+Lx -sind(theta); sind(theta) cosd(theta)+Ly]
    X=trian;
    subplot(1,2,1);
    dot2dot(X);
    title('Triángulo original')
    axis([0 20 0 20])
    subplot(1,2,2);
    dot2dot(G*X);
    title('Triángulo rotado 30º')
    axis([0 20 0 20])