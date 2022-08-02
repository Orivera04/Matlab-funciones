a = 2;
q = 1.25;                                        
th = 0:pi/40:5*pi;                               
subplot(2,2,1)                                   
plot(a*th.*cos(th), a*th.*sin(th)), ...          
    title('(a) Archimedes')    % or use polar   
subplot(2,2,2)                                   
plot(a/2*q.^th.*cos(th), a/2*q.^th.*sin(th)), ...
    title('(b) Logarithmic')   % or use polar   