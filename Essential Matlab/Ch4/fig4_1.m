     d = 45;                  
     t = 0:0.01:6;                                     
     a = d * pi / 180;                     % convert to radians             
     u = 60;                               % launch velocity                
     g = 9.8;                                                               
     x = u * t * cos(a);                   % horizontal displacement        
     y = u * t * sin(a) - 0.5 * g * t .^ 2; % vertical displacement          
     plot(x, y), xlabel('x'), ylabel('y')
