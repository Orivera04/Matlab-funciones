dt = 1/1000;
t = dt:dt:200*dt; 
sine = sin(2*pi*100*t);
y = sine + randn(size(t));
Y = fft(y);
f = fftfreq(500,length(Y));

clf
subplot(211)
stairs(t,y)
hold on
stairs(t,sine-4)
box
xlabel('Time (seconds)')

subplot(212)
stairs(f,fftshift(abs(Y)))
box
xlabel('Frequency (Hz)')
