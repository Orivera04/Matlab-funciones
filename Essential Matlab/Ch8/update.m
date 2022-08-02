K = 0.05;                                                     
F = 10;                                                       
a = 0;                 % start time                           
b = 100;               % end time                             
time = a;              % initialize time                      
T = 25;                % initialize temperature               
load train             % prepare to blow the whistle          
dt = input( 'dt: ' );                                         
opint = input( 'output interval (minutes): ' );               
if opint/dt ~= fix(opint/dt)                                  
sound(y, Fs)         % blow the whistle!                    
disp( 'output interval is not a multiple of dt!' );         
break                                                       
end                                                           
                                                            
clc                                                           
format bank                                                   
disp( '         Time          Temperature' );                 
disp( [time T] )      % display initial values                
                                                            
for time = a+dt : dt : b                                      
T = T - K * dt * (T - F);                                   
if abs(rem(time, opint)) < 1e-6    % practically zero!      
  disp( [time T] )                                          
end                                                         
end    