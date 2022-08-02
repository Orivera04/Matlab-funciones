 theta = pi/6   % radians
    G = [cos(theta) -sin(theta); sin(theta) cos(theta)]
    X1=-8:0.2:8;
    X2=X1.^2;
    X=[X1;X2];
    subplot(1,2,1);
    dot2dot(X);
    hold on;
    title('Par�bola original')
    axis([-10 10 0 10])
    plot([0;0],[0;10],'r')
    subplot(1,2,2);
    dot2dot(G*X)
    hold on;
    title('Par�bola rotada 30�')
    axis([-10 10 0 10])
    plot([0;-6],[0;10],'r')