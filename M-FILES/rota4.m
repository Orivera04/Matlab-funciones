%Rotaciones
    theta = pi/6   % radianes
    G = [cos(theta) -sin(theta); sin(theta) cos(theta)]
    X=trian;
    subplot(2,2,1);
    dot2dot(X);
    title('Tri�ngulo original')
    axis([0 10 0 10])
    subplot(2,2,2);
    dot2dot(G*X);
    title('Tri�ngulo rotado 30�')
    axis([0 10 0 10])
    subplot(2,2,3);
    theta = pi/3   % radianes
    G = [cos(theta) -sin(theta); sin(theta) cos(theta)]
    dot2dot(G*X);
    title('Tri�ngulo rotado 60�')
    axis([-10 10 0 10]);
    subplot(2,2,4);
    theta = pi/2   % radianes
    G = [cos(theta) -sin(theta); sin(theta) cos(theta)]
    dot2dot(G*X);
    title('Tri�ngulo rotado 90�')
    axis([-10 10 0 10]);