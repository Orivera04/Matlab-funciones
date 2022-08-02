% P10_18.M Compute and plot the vector position
%  of a submarine
t=(0:0.1:3)';
R=[t.^2+t+2 t.^3-t];
%
% Plot R columns vs index
figure
plot(R)
title('Submarine Path x,y vs time index')
grid
fprintf('Strike a key for next plot\n')
pause
% Plot x, y vs. time
figure
plot(t,R(:,1),':',t,R(:,2),'+')
title('Submarine Path 0 to 3 time units')
xlabel('Time units')
ylabel('Distance in x (--) and y (++)')
grid
fprintf('Strike a key for next plot\n')
pause
% Plot x vs y
figure
plot(R(:,1),R(:,2))
title('Submarine Path 0 to 3 time units')
xlabel('Distance in x')
ylabel('Distance in y')
grid

