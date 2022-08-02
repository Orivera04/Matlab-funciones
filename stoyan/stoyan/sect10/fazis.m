% © Berta Miklos 1998; program a Jelfeldolgozas c. reszhez

echo on;
N=20;Wn=[.25,.5];
[B,A]=butter(N,Wn);
[h,w]=freqz(B,A,1024,200);             % A frekvenciaatviteli
mag=abs(h);                            % fuggveny magnitudoja
phase=angle(h);                        % es fazisa
subplot(2,1,1)
plot(w,mag);             % A magnitudo kirajzolasa
xlabel('f')
grid on
subplot(2,1,2)
plot(w,phase);           % A fazis kirajzolasa 
xlabel('f')
grid on
print hbut -deps
echo off;