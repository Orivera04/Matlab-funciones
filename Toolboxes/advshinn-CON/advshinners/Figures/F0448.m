num = [1.025 0.35 -0.675];
den = [1 -2.3 1.6 -0.3 0];
t = 1:20;
[c,xtra] = deconv([num 0*t],den);
c = [zeros(1,length(t)-length(c)+1) c];
t = [length(t)-length(c)+1:0 t];
plot([1;1]*t,[0;1]*c,'-r'); grid;
xlabel('Time (sec)'); ylabel('c*(t)');