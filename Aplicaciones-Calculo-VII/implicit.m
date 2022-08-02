clc
clear all


% Mfile name
%       mtl_ode_???.m

% Revised:
%       February 28, 2011

% % Authors
%       Sri Harsha Garapati, Autar Kaw
%       Department of Mechanical Engineering
%       University of South Florida
%       Tampa, Fl 33620
%       Contact: kaw@eng.usf.edu | http://numericalmethods.eng.usf.edu/contact.html

% Purpose
%       To illustrate explicit method of solving Ordinary Differential
%       Equations
%       

% Keyword
%       Partial Differential Equations
%       Parabolic Equations
%       Implicit Method
%% Display information

% This displays title information
disp(sprintf('\n\nSimulation of the Parabolic Equation method to solve PDE'))
disp(sprintf('University of South Florida'))
disp(sprintf('United States of America'))
disp(sprintf('kaw@eng.usf.edu\n'))


% Problem Statement
% Use the implicit method to solve for the temperature distribution of a
% long, thin rod with a length of 0.05 metres subjected to a temperature of
% 100 degrees centigrade on the left end and 25 degress centigrade on the
% right end. Find the temperature distribution in the rod from t=0 secs to
% t=9 secs. The following values: K'=54 W/(m.k), C=490 J/(Kg-K) and 
% density=7800 Kg/m^3, deltax=0.01 cm, deltat=3s. At t=0, the temperature 
% of the rod is 20 degress centigrade

disp(sprintf('\n*******************************Problem Statement**********'))
disp(sprintf('Use the implicit method to solve for the temperature distribution of a'))
disp(sprintf('long, thin rod with a length of 0.05 metres subjected to a temperature of'))
disp(sprintf('100 degrees centigrade on the left end and 25 degress centigrade on the'))
disp(sprintf('right end. Find the temperature distribution in the rod from t=0 secs to'))
disp(sprintf('t=9 secs. The following values: K=54 W/(m.k), C=490 J/(Kg-K) and'))
disp(sprintf('density=7800 Kg/m^3, deltax=0.01 cm, deltat=3s. At t=0, the temperature'))
disp(sprintf('of the rod is 20 degress centigrade'))

%% Inputs
%       This is the only place in the program where the user makes the changes
%       based on their wishes

%*************************************************************************

% Length of the rod

l=0.05;

% Thermal conductivity of the material of the rod

k_prime=54;

% Specific Heat of the rod

c=490;

% density of the material of the rod

density=7800;

% Temeprature on the left end of the rod (boundary condition)

T1=100;

% Temperature on the right end of the rod (boundary condition)

T2=25;

% Intial Temperature
Ti=20;

% number of divisions on the rod
n=5;

%End time of the analysis
t=9;

%Time step

dt=3;

%*************************************************************************

disp(sprintf('\n\n********************************Input Data**********************************\n')) 
disp(sprintf('     L = %g, Length of the rod ',l)) 
disp(sprintf('     K = %g, Thermal conductivity of the rod ',k_prime))
disp(sprintf('     C = %g, Specific Heat of the rod ',c))
disp(sprintf('     Density = %g, Density of the rod ',density))
disp(sprintf('     T1 = %g, Temperature on the left side of the rod ',T1))
disp(sprintf('     T2 = %g, Temperature on the right side of the rod ',T2))
disp(sprintf('     n = %g, Number of sections of the grid along the length of the rod',n))
disp(sprintf('     T = %g, End time of the analysis',t))
disp(sprintf('     dt = %g, Time step of the analysis',dt))



%*************************************************************************
%% Calculations

disp(sprintf('\n\n********************************Calculated Data**********************************\n')) 

% Calculating the number of time steps required for the analysis
runs=t/dt + 1;

% Step size along the length of the rod

dx=l/n;

% alpha=thermal diffusivity

alpha=k_prime/(c*density);

% Relaxation
lambda=alpha*dt/(dx)^2;

disp(sprintf('     alpha = %g, Thermal diffusivity',alpha))


%% Programming the Explicit Method
%Generating the linear cordinates of the nodes
for i=1:1:n+1
    L(i)=(i-1)*dx;
end


% Starting values assignmed to the Temperature vector
T=zeros(runs,n+1);


% Loop Assigning the Boundary Conditions to Temperature Vector
for i=1:1:runs
     T(i,1)=T1;
     T(i,n+1)=T2;
end


% Loop Assigning the Initial Conditions to Temperature Vector
for j=2:1:n
     T(1,j)=Ti;
end

% Programming the explicit method

for j=1:1:runs-1
    
    temp=zeros(n-1,n-1);
    cons=zeros(n-1,1);
    for i=2:1:n
        k=i-1;
        
        if k==1
        temp(k,k)=1+(2*lambda);
        temp(k,k+1)=-lambda;
        cons(k,1)=T(j,i) + (lambda*T(j+1,i-1));
        
        end
    
        if k ~=1 && k ~=n-1
        temp(k,k-1)=-lambda;
        temp(k,k)=1+ (2*lambda);
        temp(k,k+1)=-lambda;
        cons(k,1)=T(j,i);
        end
    
        if k==n-1
            temp(k,k-1)=-lambda;
            temp(k,k)=1+ (2*lambda);
            cons(k,1)=T(j,i) + (lambda*T(j+1,i+1));
        end
    
    end
  
    sol=temp\cons;
    
    for i=2:1:n
        T(j+1,i)=sol(i-1);
    end
end
%% Output
disp('Here in the temperature matrix, T, each row represents the time step')
disp('and each column represents the time, i.e. first row represents the') 
disp('initial time step, second row represents the first time step and the')
disp('last row represents the end time of the analysis. Ex: T(3,2) represents ')
disp(' the temperature of the second node at the third time step')
disp(' ')
disp(' Temperature, T=')
disp(T)
%% Plotting

% Loop to record movie
for j = 0:1:runs-1
    for i=1:1:n+1
        T_M(i)=T(j+1,i);
        
    end
    plot(L,T_M);
    xlabel('Length of the rod')
    ylabel('Temperature')
    legend(['Time=' num2str(j*dt)])
    title('Recording movie...')
    % Get every frame with 'getframe' and load the appropriate       % matrix.
    frames(j+1) = getframe;
end

% Save the matrix so that this movie can be loaded later
save frames 

% Play the movie once, 1 FPS.
title('Movie being played back...')
movie(frames,1,1)


% % Creating the temperature array when time =0
% for i=1:1:n+1
% T_0(i)=T(1,i);
% end
% 
% % Creating the temperature array when time =T/4
% for i=1:1:n+1
% T_1(i)=T(((runs-1)/4+1),i);
% end
% 
% % Creating the temperature array when time =T/2
% for i=1:1:n+1
% T_2(i)=T((2*(runs-1)/4+1),i);
% end
% 
% % Creating the temperature array when time =3T/4
% for i=1:1:n+1
% T_3(i)=T((3*(runs-1)/4+1),i);
% end
% 
% % Creating the temperature array when time =T
% for i=1:1:n+1
% T_4(i)=T((4*(runs-1)/4+1),i);
% end
% 
% Time_0_0th=['Time=' num2str(0)];
% Time_1_4th=['Time=' num2str(((runs-1)/4)*dt)];
% Time_1_2th=['Time=' num2str((2*(runs-1)/4)*dt)];
% Time_3_4th=['Time=' num2str((3*(runs-1)/4)*dt)];
% Time_1_1th=['Time=' num2str((4*(runs-1)/4)*dt)];
% 
% % Plot command
% plot(L,T_0,L,T_1,L,T_2,L,T_3,L,T_4)
% title('Temperature Vs Length')
% xlabel('Length of the rod')
% ylabel('Temperature')
% legend(Time_0_0th,Time_1_4th,Time_1_2th,Time_3_4th,Time_1_1th)
% 
