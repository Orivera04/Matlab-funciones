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
%       To illustrate elliptic method of solving Partial Differential
%       Equations
%       

% Keyword
%       Paratial Differential Equations
%       Elliptic Equations
%       Gauss-Siedel Method
%% Display information

% This displays title information
disp(sprintf('\n\nSimulation of the Elliptic PDE'))
disp(sprintf('University of South Florida'))
disp(sprintf('United States of America'))
disp(sprintf('kaw@eng.usf.edu\n'))


% Problem Statement
% Matlab worksheet to solve for the temperature distribution of a
% rectangular plate with a length of 2.4 m and width of 3.0 m. The plate is
% subjected to dirichlet temperature boundary conditions on the foursides
% of the plate

disp(sprintf('\n*******************************Problem Statement**********'))
disp(sprintf('Matlab worksheet to solve for the temperature distribution of a'))
disp(sprintf('rectangular plate with a length of 2.4 m and width of 3.0 m'))
disp(sprintf('The plate is sibjected to temperature boundary conditions'))


%% Inputs
%       This is the only place in the program where the user makes the changes
%       based on their wishes

%*************************************************************************

% Length of the plate

l=2.4;

% Width of the plate

w=3.0;

% Temeprature on the left end of the plate (boundary condition)

T_L=75;

% Temperature on the right end of the plate (boundary condition)

T_R=100;

% Temeprature on the top end of the plate (boundary condition)

T_T=300;

% Temperature on the bottom end of the plate (boundary condition)

T_B=50;

% Grid Length of the square mesh (mesh size)

dx=0.6;

% tolerance
tol=1;


%*************************************************************************

disp(sprintf('\n\n********************************Input Data**********************************\n')) 
disp(sprintf('   L = %g, Length of the plate ',l)) 
disp(sprintf('   W = %g, width of the plate ',w)) 
disp(sprintf('   dx = %g, mesh size ',dx)) 
disp(sprintf('   TL = %g, Temperature at the left end of the plate ',T_L)) 
disp(sprintf('   TR = %g, Temperature at the right end of the plate ',T_R))
disp(sprintf('   TT = %g, Temperature at the top end of the plate ',T_T))
disp(sprintf('   TB = %g, Temperature at the bottom end of the plate ',T_B))


%*************************************************************************
%% Calculations

disp(sprintf('\n\n********************************Calculated Data**********************************\n')) 

% Square grid

dy=dx;

% Number of elements along the length of the plate

m=l/dx;

% Number of elements along the width of the plate

n=w/dy;

disp(sprintf('     m = %g, Number of elements along the length of the plate ',m))
disp(sprintf('     n = %g, Number of elements along the width of the plate ',n))
%% Plate distribution
 fprintf(' \n \n \t \t \t \t \t \t \t  %g \n',T_T)
 disp('               -----------------------------       ')
 disp('               |                            |      ')
 disp('               |                            |      ')
 disp('               |                            |      ')
 fprintf(' \t \t %g    |                            | \t %g      \n',T_L,T_R)
 disp('               |                            |      ')
 disp('               |                            |      ')
 disp('               |                            |      ')
 disp('               -----------------------------       ')
 fprintf(' \t \t \t \t \t \t \t  %g \n \n \n',T_B)
 disp('To give a better idea the nodal locations are also given as the')
 disp('cordinates of x&y and the origin is choosen at the intersection of') 
 disp('bottom edge and left edge')

%% Programming the Gauss Siedel Method
% Generating the temperature matrix
T=zeros(n+1,m+1);

% Assigning the temperature boundary conditions
for i=1:1:n+1
    for j=1:1:m+1
        if (i==1)
            T(i,j)=T_B;
        end
     
        if(i==n+1)
            T(i,j)=T_T;
        end
     
        if(j==1)
            T(i,j)=T_L;
        end
     
        if(j==m+1)
            T(i,j)=T_R;
        end
    end
end

iteration=0;
disp(sprintf('Temperature distribution after iteration %g ',iteration))
disp(T)
count=(m-1)*(n-1);
while(count>0)
count=0;
    for i=2:1:n
        for j=2:1:m
            old=T(i,j);
            T(i,j)=( T(i+1,j)+T(i-1,j)+T(i,j+1)+T(i,j-1) )/4;
            epsa(i,j)= abs( (T(i,j)-old) /T(i,j)*100 );
         
            if(epsa(i,j)>tol)
                count=count+1;
            end
         
        end 
 end
 iteration=iteration+1;
 disp(sprintf('Temperature distribution after iteration %g ',iteration))
 
 for i=1:1:n+1
     for j=1:1:m+1
        T_display(i,j)=T(n+1-i+1,j);  
     end
 end
 
 for i=2:1:n
     for j=2:1:m
         epsa_display(i,j)=epsa(n+1-i+1,j);
     end
 end
 
 
 disp('T=')
 disp(T_display)
 disp(' Absolute relative percentage error at each node')
 disp('epsa=')
 disp(epsa_display)
end 

%% Plotting
L=0:dx:l;
W=0:dy:w;

figure(1)
h=surf(L,W,T);view(2)
shading interp
grid on
colorbar
Title(' Steady state temperature distribution in the plate')
xlabel('Length of the rod')
ylabel('Width of the rod')

