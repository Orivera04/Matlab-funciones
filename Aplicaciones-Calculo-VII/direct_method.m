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
%       Direct method
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

% square mesh so, dx=dy
dy=dx;

% Number of elements along the length of the plate
m=l/dx;

% Number of elements along the width of the plate
n=w/dy;

disp(sprintf('   m = %g, number of divisions along the length of the plate ',m)) 
disp(sprintf('   n = %g, number of divisions along the width of the plate ',n)) 
%% Programming the Solution to  Ellptic Equations
A=zeros((m-1)*(n-1),(m-1)*(n-1));
B=zeros((m-1)*(n-1),1);
count=0;
% creating the coeffcient matrix
for i=1:1:(m-1)*(n-1)
    j=i;
    count=count+1;
    A(i,j)=-4;
    if (count~=1)
        A(i,j-1)=1;
    end
     if (count~=n-1)
         A(i,j+1)=1;
     end
      if(j+n-1<=(m-1)*(n-1) )
          A(i,j+n-1)=1;
      end
      if (j-n+1>0)
          A(i,j-n+1)=1;
      end
      if (count==n-1)
          count=0;
      end    
end

count=0;
% creating the right hand side matrix
 for i=1:1:m-1
     for j=1:1:n-1
        count=count+1;
        temp1=0;
        temp2=0;
         if (i-1==0)
             temp1=T_L;
         elseif (i+1==m)
             temp1=T_R;
         end
          if(j-1==0)
              temp2=T_T;
          elseif (j+1==n)
              temp2=T_B;
          end
          B(count,1)=-(temp1+temp2);
     end
 end

 % solving for temperatures
 sol=A\B;
 
 count=0;
 
 % Assigning the solution temperatures to respective internal nodes
 for i=1:1:m-1
     for j=1:1:n-1
         count=count+1;
         T_internal(i,j)=sol(count,1);
     end
 end
 T_internal=transpose(T_internal);
 
 % Creating a matrix with both internal and boundary nodes
 for i=1:1:n+1
     for j=1:1:m+1
         if (i==1)
             T(i,j)=T_T;
         elseif (i==n+1)
             T(i,j)=T_B;
         elseif (j==1)
             T(i,j)=T_L;
         elseif (j==m+1)
             T(i,j)=T_R;
         else
             T(i,j)=0;
         end
     end
 end
 for i=1:1:n-1
     for j=1:1:m-1
         T(i+1,j+1)=T_internal(i,j);
     end
 end
         
         
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
 
 %% Outputs 
 disp(sprintf('\n\n********************************Temperature Distribution**********************************\n')) 
 disp('Here in the temperature matrix the each matrix location represents')
 disp('the temperature of the node at that location')
 disp('T=');
 disp(T)
%% Plotting
L=0:dx:l;
W=0:dy:w;

for i=1:1:n+1
    for j=1:1:m+1
        T_display(i,j)=T(n+2-i,j);
    end 
end

figure(1)
h=surf(L,W,T_display);view(2)
shading interp
grid on
colorbar
Title(' Steady state temperature distribution in the plate')
xlabel('Length of the rod')
ylabel('Width of the rod')


    
       
          
        
         
        
            