%Rotación de trapecio
    %theta = -pi/6   % radians
    %G = [cos(theta) -sin(theta); sin(theta) cos(theta)]
    G=[2/sqrt(5) 1/sqrt(5); -1/sqrt(5) 2/sqrt(5) ]
    %theta = 30  % degrees
    %G = [cosd(theta) -sind(theta); sind(theta) cosd(theta)]
    
    %Primera figura
    X=trapecio;
    subplot(1,3,1);
    dot2dot(X);
    title('Trapecio original');
    axis([0 10 0 10]);
    
    %Segunda figura
    subplot(1,3,2);
    traprot=G*X;
    dot2dot(traprot);
    title('Trapecio rotado')
    axis([0 10 0 10]);
    %Tercera figura
    subplot(1,3,3);
    G=[2/sqrt(5) 1/sqrt(5); 1/sqrt(5) 2/sqrt(5) ];
    dot2dot(G*traprot);
    title('Trapecio rotado')
    axis([0 10 0 10])
    
    