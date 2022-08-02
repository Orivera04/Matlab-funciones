% PART I (General information)
% A Program For Analysis of A Uniform Pulse Width Modulation Of An AC 
% Signal.
% By: Yasin A. Shiboul
% Date 1/3/2003
%
% PART II (preparation)
% In this part the screen is cleared, any other functions, figures and 
% variables are also cleared. The name of the programm is displayed.
clc
clear all
disp('Uniform Pulse Width Modulation of AC Signal')
disp('  ')
%
% PART III
% In this part the already known variables are entered, the user is 
% asked to enter the other variables.
% Vrin is the rms value of the input supply voltage in per unit.
Vrin=1;
% f is the frequency of the input supply voltage.
f=input('The frequency of the input supply voltage, f = ');
% Z is the load impedance in per unit. 
Z=1;
% ma is the modulation index
ma=input('the modulation index,ma, (0<ma<1), ma = ');
% phi is load-phase-angle
phi=input('the phase angle of the load in degrees = ');
% Q is the number of pulses per half-period of the supply voltage.
Q=input('The number of pulses per half period = ');
%
% PART IV
% Calculating load parameters.
%
phi=phi*pi/180;
% R and L are the load resistance and inductance respectively.
R=Z*cos(phi);
L=(Z*sin(phi))/(2*pi*f);
%
% PART V
% Calculating the number of pulses per period,N
N=2*Q;
%
%PART VI
% Building the Sawtooth signal,Vt, the Input voltage waveform,Vin, 
% the Output voltage waveform, Vout, and finding the beginning (alpha)
% and the end (beta)for each of the output pulses.
%
% In each period of the sawtooth, there is one increasing and 
% decreasing part of the sawtooth, thus the period of the input 
% supply is divided into into 2N sub-periods, k is used as a counter
% of these sub-periods.
%
% for calculation purposes each of these sub-periods is divided into
% 50 points, i.e., the input supply period is divided into 100N points.
% j is a counter inside the sub-period
% i is the generalized time counter

for k=1:2*N
    for j=1:50
      % finding the generalized time counter
      i=j+(k-1)*50;
      % finding the time steps
      wt(i)=i*pi/(N*50);
      % calculating the input supply voltage.
      Vin(i)=sqrt(2)*Vrin*sin(wt(i));
      % calculating the sawtooth waveform
      if rem(k,2)==0
         Vt(i)=0.02*j;
         if abs(Vt(i)-ma)<=0.011
            m=j;
            beta(fix(k/2)+1)=3.6*((k-1)*50+m)/N;
         else
            j=j;
         end
         
      else
         Vt(i)=1-0.02*j;
         if abs(Vt(i)-ma)<0.011
            l=j;
            alpha(fix(k/2)+1)= 3.6*((k-1)*50+l)/N;
         else
            j=j;
         end
         
      end
      if Vt(i)>=ma
         Vout(i)=0;
      else
         Vout(i)=Vin(i);
      end
      
   end
end

beta(1)=[];   

% PART VII
% Displaying the beginning (alpha), the end (beta) and the width 
% of each of the output pulses.

disp('  ')  
disp('......................................................................')
disp('alpha    beta    width')
[alpha'  beta'  (beta-alpha)']

% PART VIII
% Plotting the input voltage waveform Vin, the triangular carrier 
% signal,Vt,% the modulation index, ma, and the output voltage 
% waveform, Vout.

a=0;
subplot(3,1,1)
plot(wt,Vin,wt,a)
axis([0,2*pi,-2,2])
title('Generation Of The Output Voltage Pulses ')
ylabel('Vin(pu)');

subplot(3,1,2)
plot(wt,Vt,wt,ma,wt,a)
axis([0,2*pi,-2,2])
ylabel('Vt, ma(pu)');

subplot(3,1,3)
plot(wt,Vout,wt,a)
axis([0,2*pi,-2,2])
ylabel('Vo(pu)');
xlabel('Radian');

% PART IX
% Analyzing the output voltage waveform

% Finding the rms value of the output voltage
Vo =sqrt(1/(length(Vout))*sum(Vout.^2));
disp('The rms Value of the Output Voltage ')
Vo

% finding the harmonic contents of the output voltage waveform
y=fft(Vout);
y(1)=[];
x=abs(y);
x=(sqrt(2)/(length(Vout)))*x;
disp('The rms Value of the output voltage fundamental component = ')
x(1)

% Findint the THD of the output voltage
THDVo = sqrt(Vo^2 -x(1)^2)/x(1);

% PART X
% calculating the output current waveform
m=R/(2*pi*f*L);
DT=pi/(N*50);
C(1)=-10;

i=100*N+1:2000*N;
Vout(i)=Vout(i-100*N*fix(i/(100*N))+1);

for i=2:2000*N;
C(i)=C(i-1)*exp(-m*DT)+Vout(i-1)/R*(1-exp(-m*DT));
end


% PART XI
% Analyzing the output current waveform

% finding the harmonic contents of the output current waveform
for j4=1:100*N
    CO(j4)=C(j4+1900*N);
CO2= fft(CO);
CO2(1)=[];
COX=abs(CO2);
COX=(sqrt(2)/(100*N))*COX;
end

% Finding the RMS value of the output current.
CORMS = sqrt(sum(CO.^2)/(length(CO)));
disp(' The RMS value of the load current is')
CORMS

%Finding the THD for the output current
THDIo = sqrt(CORMS^2-COX(1)^2)/COX(1);

% PART XII
% Finding the supply current waveform
 
for j2=1900*N+1:2000*N
    if Vout(j2)~=0
        CS(j2)=C(j2);
    else
        CS(j2)=0;
    end
end 
% PART XIII
% Analyzing the supply current waveform

%Supply current waveform and its RMS
for j3=1:100*N
    CS1(j3)=CS(j3+1900*N);
end
    CSRMS= sqrt(sum(CS1.^2)/(length(CS1)));
    disp('The RMS value of the supply current is')
    CSRMS
    
% Finding the Fourier analysis

    CS2= fft(CS1);
CS2(1)=[];
CSX=abs(CS2);
CSX=(sqrt(2)/(100*N))*CSX;

% Finding the THD of the Supply current
THDIS = sqrt(CSRMS^2-CSX(1)^2)/CSX(1);
% Finding the Displacement Factor of the supply current
phi1 = atan(real(CS2(1))/imag(CS2(1)))-pi/2;

PF=cos(phi1)*CSX(1)/CSRMS;


% PART XIV
% Displaying the calculated parameters.
disp(' Performance parameters are')
THDVo
THDIo
THDIS
PF

a=0;

%PART XV
% Openning a new figure window for plotting of 
% the output voltage,output current, supply current and the harmonic
% contents of these values

figure(2)

 subplot(3,2,1)
 plot(wt,Vout(1:100*N),wt,a);
 title('');
 axis([0,2*pi,-1.5,1.5]);
 ylabel('Vo(pu)');
 %
 
 subplot(3,2,2)
 plot(x(1:100))
 title('');
 axis([0,100,0,0.8]);
 ylabel('Von(pu)');
 
 subplot(3,2,3)
 plot(wt,C(1900*N+1:2000*N),wt,a);
 title('');
 axis([0,2*pi,-1.5,1.5]);
 ylabel('Io(pu)');

 subplot(3,2,4)
  plot(COX(1:100))
 title('');
  axis([0,100,0,0.8]);
 ylabel('Ion(pu)');
 
subplot(3,2,5)
plot(wt,CS(1900*N+1:2000*N),wt,a);
axis([0,2*pi,-1.5,1.5]);
 ylabel('Is(pu)');
 xlabel('Radian');

  subplot(3,2,6)
 plot(CSX(1:100))
 title('');
  axis([0,100,0,0.8]);
 ylabel('Isn(pu)');
 xlabel('Harmonic Order');
 