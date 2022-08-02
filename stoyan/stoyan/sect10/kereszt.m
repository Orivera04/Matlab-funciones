% © Berta Miklos 1998; program a Jelfeldolgozas c. reszhez

echo on;
dt=.01;             % Az idolepes masodpercben
N=1024;             % Az adatblokk hossza
H=.1;               % A Gauss-eloszlasu hatterzaj szorasa
n=[0:N-1]';t=n*dt;  % A mintaveteli idopillanatok vektora
jel1=H*randn(size(t));    % Az elso jel 
jel2=H*randn(size(t));    % A masodik jel
jel1(10)=jel1(10)+5;jel2(40)=jel2(40)+5; % A tuimpulzusok
                                % hatasa az egyes jelekre
for m=1:N/2,                           % A keresztkorrelacios
    a=jel1(1:N/2);b=jel2(m:(N/2)-1+m); % fuggveny szamitasa.
    R(m)=(2/N)*sum(a.*b);  
end
R=R';
plot(t(1:51),R(1:51)), 
title('Crosscorelation function')   % A fuggveny 
                                    % grafikonjanak 
xlabel('dt'),                       % kirajzolasa
grid on;
print Rxy.eps -deps
clear;
echo off;