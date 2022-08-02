% P6_16.M Create pulse of arbitrary length
%  
clear
clf
% Input Pulse length 
Tstart=input('Input Tstart of pulse = ')
Tend=input('Input Tend of pulse = ')
Tfinal=input('Input Final time Tfinal = ')
N=input('Number of points in pulse = ')
%
% Pulse_to_plot - a column vector of length length_t
%
deltat=(Tend-Tstart)/N
t=[Tstart:deltat:Tfinal];
length_t=length(t)
for i=1:length_t
  if t(i) < Tstart     
       pulse_to_plot(i) = 0;
  elseif (Tstart <= t(i)) & (t(i) <= Tend) 
       pulse_to_plot(i) = 1;
  elseif t(i) > Tend 
       pulse_to_plot(i) = 0;
  end
end
%pulse_to_plot= (pulse_to_plot)';
plot(t,pulse_to_plot,'*')       % Plot the solution
title('Plot of Pulse')
xlabel('Time')
ylabel('Pulse')
grid
zoom
%
% Add comments to define the input variables and output.
%