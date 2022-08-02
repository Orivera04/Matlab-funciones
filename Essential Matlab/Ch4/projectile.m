d = input( 'Angle of projection in degrees: ' );                           
t = input( 'Time in flight: ' );                                           
a = d * pi / 180;     % convert to radians                 
u = 60;               % launch velocity                    
g = 9.8;                                                                   
x = u * t * cos(a);   % horizontal displacement            
y = u * t * sin(a) - 0.5 * g * t ^ 2; % vertical ...
                                   % displacement              
vx = u * cos(a);                   % horizontal velocity                
vy = u * sin(a) - g * t;           % vertical velocity                  
V = sqrt( vx^2 + vy^2 );           % resultant velocity                 
th = 180 / pi * atan2( vy, vx );   % direction at time t        
disp( ['x:  ' num2str(x) '   y:  ' num2str(y)] );                                  
disp( ['V:  ' num2str(V) '  th:  ' num2str(th)] ); 