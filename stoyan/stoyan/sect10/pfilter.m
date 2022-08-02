% © Berta Miklos 1998; program a Jelfeldolgozas c. reszhez

echo on;
N=1024;                            % Adatpontok szama
t=0:.001:1.023;                    % Az idoskala
a=[1 -.9];b=[.9e-7];               % A szuro parameterei
x=[1 zeros(1,N-1)];                % Egysegimpulzus
y=filter(b,a,x);                   % A szurt egysegimpulzus
f=813*t;
plot(f(1:128),y(1:128));           % Az egysegimpulzus
xlabel('f')
grid on                            % atviteli fuggveny
print hdel -deps                   % kirajzolasa
pause;
[h,w]=freqz(b,a,N,1000);           % A frekvenciaatviteli
mag=abs(h);                        % fuggveny magnitudoja
phase=angle(h);                    % es fazisa
subplot(2,1,1)
plot(w(1:256),mag(1:256));         % A magnitudo kirajzolasa
xlabel('f')
grid on
subplot(2,1,2)
plot(w(1:256),phase(1:256));       % A fazis kirajzolasa 
xlabel('f')
grid on
print hfrek -deps
echo off;