%Rotaciones
    theta = pi/6   % radianes
    G = [cos(theta) -sin(theta); sin(theta) cos(theta)]
    X=trian;
    subplot(2,2,1);
    dot2dot(X);
    title('Triángulo original')
    axis([0 10 0 10])
    subplot(2,2,2);
    dot2dot(G*X);
    title('Triángulo rotado 30º')
    axis([0 10 0 10])
    subplot(2,2,3);
    theta = pi/3   % radianes
    G = [cos(theta) -sin(theta); sin(theta) cos(theta)]
    dot2dot(G*X);
    title('Triángulo rotado 60º')
    axis([-10 10 0 10]);
    subplot(2,2,4);
    theta = pi/2   % radianes
    G = [cos(theta) -sin(theta); sin(theta) cos(theta)]
    dot2dot(G*X);
    title('Triángulo rotado 90º')
    axis([-10 10 0 10]);