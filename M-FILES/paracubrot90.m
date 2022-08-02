theta = -pi/2   % radians
    G = [cos(theta) -sin(theta); sin(theta) cos(theta)]
    X1=-8:0.1:8;
    X2=X1.^3;
    X=[X1;X2];
    subplot(1,2,1);
    dot2dot1(X);
    hold on;
    title('Parábola cúbica original')
    axis([-10 10 -10 10])
    %plot([0;0],[0;10],'r')
    subplot(1,2,2);
    dot2dot1(G*X)
    hold on;
    title('Parábola cúbica rotada 90º')
    axis([-10 10 -10 10])
    %plot([0;-6],[0;10],'r')