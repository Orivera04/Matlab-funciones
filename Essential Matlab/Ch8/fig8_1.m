       dt = 0.1;                                            
       g = 9.8;                                             
       u = 60;                                              
       ang = input( 'Launch angle in degrees: ' );          
       ang = ang * pi / 180;            % convert to radians
       xp = zeros(1); yp = zeros(1);    % initialize
       y = 0; t = 0;                                         
       i = 1;               % initial vector subscript
       
       while y >= 0             
         t = t + dt;                                       
         i = i + 1;                                        
         y = u * sin(ang) * t - g * t^2 / 2;               
         if y >= 0                                         
           xp(i) = u * cos(ang) * t;                       
           yp(i) = y;                                      
         end                                               
       end                                                 
                                                           
       plot(xp, yp,'k'),grid                                   
