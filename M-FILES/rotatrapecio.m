%Rotación de trapecio
    %theta = -pi/6   % radians
    %G = [cos(theta) -sin(theta); sin(theta) cos(theta)]
    G=[2/sqrt(5) 1/sqrt(5); -1/sqrt(5) 2/sqrt(5) ]
    %theta = 30  % degrees
    %G = [cosd(theta) -sind(theta); sind(theta) cosd(theta)]
    
    %Primera figura
    X=trapecio;
    subplot(2,2,1);
    dot2dot(X);
    title('Trapecio original');
    axis([0 10 0 10]);
    
    %Segunda figura
    subplot(2,2,2);
    traprot=G*X;
    dot2dot(traprot);
    title('Trapecio rotado')
    axis([0 10 0 10]);
    
    %Tercera figura
    traprot=G*X;
    traprot(1,6)=traprot(1,2);
    traprot(2,6)=traprot(2,1);
    traprot(1,7)=traprot(1,3);
    traprot(2,7)=traprot(2,1);
    subplot(2,2,3);
    dot2dot(traprot);
    title('Trapecio nuevo')
    axis([0 10 0 10])
    
    %Cuarta figura
    subplot(2,2,4);
    G=[2/sqrt(5) 1/sqrt(5); 1/sqrt(5) 2/sqrt(5) ];
    dot2dot(G*traprot);
    title('Trapecio nuevo rotado')
    axis([0 10 0 10])