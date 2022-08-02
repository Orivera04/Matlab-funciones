K = 0.05;                                                     
F = 10;                                                       
time = 0:100;             % initialize vector time                   
T = zeros(1,101);         % pre-allocate vector T                    
T(1) = 25;                % initial temperature of OJ              
                                                            
for i = 1:100                      % time in minutes                
T(i+1) = T(i) - K * (T(i) - F);  % construct T              
end;                                                              
                                                            
disp([ time(1:5:101)' T(1:5:101)' ]);  % display results      
plot(time, T), grid                    % every 5 mins  