  theta = pi/6   % radians
    G = [cos(theta) -sin(theta); sin(theta) cos(theta)]
    X=[1 5;1 1];
    subplot(1,2,1);
    dot2dot(X);
    hold on;
    title('figura original')
    axis([0 10 0 10])
    plot([1;10],[1;1])
    subplot(1,2,2);
    dot2dot(G*X)
    hold on;
    title('figura rotada 30º')
    axis([0 10 0 10])
    plot([0;10],[1;1])