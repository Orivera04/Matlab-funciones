% © Berta Miklos 1998; program a Jelfeldolgozas c. reszhez

echo on
clc
load J1.asc;            % jelbeolvasas
load J9.asc;            % jelbeolvasas
jel1=J1;
jel2=J9;
F_s=100  % Hz           % mintaveteli frekvencia
dt=1/F_s % sec          % idolepes
k=-512:1:511;
atlagszam=63;           % spektralis atlagolas szama
SXY1=0+0*k;             % valtozo inicializalasa
SXY=SXY1';              
SXX=SXY1';
SYY=SXY1';
for i=1:atlagszam,      % spektralis atlagolas kezedete
    J=1+(i-1)*1024;     % jelszeleteles boxcar ablakkal
    K=J+1023;
    x=jel1(J:K);
    y=jel2(J:K);
    Fxx=fft(x);             % idoszelet fft-je
    Fyy=fft(y);             % idoszelet fft-je
    Sxx=conj(Fxx).*Fxx/1024; % periodogram (APSD)
    Syy=conj(Fyy).*Fyy/1024; % periodogram (APSD)
    Sxy=conj(Fxx).*Fyy/1024; % periodogram (CPSD)
    SXX=(SXX+Sxx);
    SYY=(SYY+Syy);
    SXY=(SXY+Sxy);
end 
CXX=SXX/atlagszam;       % CXX -> az elso jel APSD-je
CYY=SYY/atlagszam;       % CYY -> a masodik jel APSD-je
CXY=SXY/atlagszam;       % CXY -> a ket jel keresztspektruma
CMXY=abs(CXY);           % CPSD magnitudoja
logcxx=log10(CXX);       % atteres log skalara
logcyy=log10(CYY);       
CFXY=angle(CXY);         % a CPSD fazisa
KOHXY=CMXY.^2./(CXX.*CYY);  % a ket jel koherenciaja
f = 100/1024*(0:511);    % a frekvencia skala
figure(20)               % eredmenyek rajzolasa
subplot(2,2,1)
   plot(f(1:127),logcxx(1:127)), title('APSD1'),
   axis([0 10 2 7])
   xlabel('Frequency (Hz)')
   ylabel('log(APSD1|)')
   grid on
subplot(2,2,3)
   plot(f(1:127),logcyy(1:127)), title('APSD2'),
   axis([0 10 2 7])
   xlabel('Frequency (Hz)')
   ylabel('log(|APSD2|)')
   grid on
subplot(2,2,2)
   plot(f(1:127),CFXY(1:127)), title('Phase of CPSD'),
   axis([0 10 -3.15 3.15])
   xlabel('Frequency (Hz)')
   ylabel('PHASE')
   grid on
subplot(2,2,4)
   plot(f(1:127),KOHXY(1:127)), title('Coherence of signals'),
   axis([0 10 0 1])
   xlabel('Frequency (Hz)')
   ylabel('COHERENCE')
   grid on
print stat -deps     % abra elmentese fileba
clc
echo off
disp('End')