%Rotaciones
    theta = pi/6   % radians
    G = [cos(theta) -sin(theta); sin(theta) cos(theta)]
    %theta = 30  % degrees
    %G = [cosd(theta) -sind(theta); sind(theta) cosd(theta)]
    X=trian;
    subplot(1,2,1);
    dot2dot(X);
    title('Triángulo original')
    axis([0 10 0 10])
    subplot(1,2,2);
    dot2dot(G*X);
    title('Triángulo rotado 30º')
    axis([0 10 0 10])