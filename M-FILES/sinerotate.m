X = [-pi/2:pi/20:pi/2]'; Y = sin(X);
               final_coords = rotation([X-pi,Y],[0,0],90);
               figure;
               subplot(2,1,1),plot(X,Y,'b');grid on;
               title('Gráfica original');
               subplot(2,1,2),plot(final_coords(:,1),final_coords(:,2),'r');
               title('Gráfica rotada 90º')
               grid on;