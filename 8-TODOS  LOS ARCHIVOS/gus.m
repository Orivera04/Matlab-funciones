%This program aske you to input the square matrix of equations coefficient ansd solve it by three METHODS:
% 1)Gauss Jordan Method
%2)Gauss seidel Method
%3)Successive Relaxation Method

%there are also ploting of three METHODS
%you will find the answer on the txt file calld (results)
% this program good for circuit analysis and calculte erorrs...
%#######################################################################
%###            Author:Mohammed Saleh                                ###
%## Email: alahmadi495@hotmail.com           Univercity Of Sharjah   ###
%#######################################################################
%24-11-2004
clear
%entering the matrix size

state=1;
 while state~=0;%while 1
     clear
     RC =input ('Enter the Number of meshes(NOT MORE THAN 10):'); 
     if (RC>10);
        while (RC>10);
         disp('You have entered a bigger number than the range');
         disp(' ');
         RC =input ('Enter the Number of meshes(NOT MORE THAN 10):'); 
        end
    end
    %input
    tol= input ('Enter The Tolerance: ');disp(' ');
    ig= input('Enter The initial Guess Terminal as Matrix [ I1 I2 I3 ...]mA:');
    disp(' ');
    alpha=input('Enter ALPHA :');
    ig=ig';
    igprint=ig;% for print
    
      
%Display definitions of inputs
    disp('************************************************************');
    disp('*    The Rii means the sum of resistors on mesh i          *');
    disp('* The Rij mean the negative of resistors between mesh j& i *');
    disp('************************************************************');
  
 % Enter the Resistor Matrix Values
    for i= 1:RC;
       %Enter row by row in the symmetric matrix
       for j=i:RC;
           fprintf('Enter in kohms R %1.0f %1.0f=',i,j);
           R(i,j)=input (' ');
           R(j,i)= R(i,j);%copy to symmetric
       end
   end
   
 %Display definitions of inputs
    disp('************************************************************');
    disp('*            The Vi means the sum of mesh i                *');
    disp('************************************************************');
 % Enter the voltage Matrix Values
 for i=1:RC;
     fprintf('Enter in Voltage V %1.0f=',i);
     V(i,1)=input (' ');     
 end
 
%*****************************************************************************  
%*****************************************************************************
%**************************  Calculation body    *****************************
%************************   Gauss Jordan Method   ****************************
%*****************************************************************************
 
%I.Creating C Matrix [R,V]
%Copying R to C
C = R;

%Adding Voltage matrix to the C Matrix
RCx=RC +1; %new extended colomn of C
for i=1:RC;
    C(i,RCx)= V(i,1);
end



for j= 1:RC; %Global operation loop
%Finding out the maximum header and its row number
max=0;
for i=j:RC;
    if abs(C(i,j))> max; 
    max = C(i,j);
    rownumber=i;
    end
end

%Sorting for the maximum number
Temp = C (rownumber,:);
C (rownumber,:) = C (j,:);
C (j,:) = Temp;


%dividing each row on the diagonal line with biggest number to equal 1
C (j,:) = C (j,:) / C(j,j);


%Set all linear equations below header to zero

for i=1:RC;
    Temp = C (j,:);
    if i ~= j
    factor = C(i,j);
    Temp = Temp * factor;
    C(i,:)= C(i,:) - Temp;
    end
end
end %end of Global operation loop


%*********************************
%print on File results
%********************************

f1 = fopen('results','w');

fprintf(f1,'R (K ohm) :\n');   
for i=1:RC;
    for j=1:RC;
        fprintf(f1,' %3.6f\t\t',R(i,j));
    end
    fprintf(f1,'\n');
end
fprintf(f1,'\n\n voltage (V): ');
for i=1:RC;%print the voltage input
    fprintf(f1,'\t%3.6f\n',V(i,1));
end
 
fprintf(f1,'\n\n  Tolerance (mA) = %0.6f\n',tol);
fprintf(f1,'\n\n  Relaxation Factor  = %0.6f\n',alpha);
fprintf(f1,'\n\n  Initial Guess Terminal  (mA)=\n');
fprintf(f1,'                                    %3.6f\n',igprint);
fprintf(f1,'  \n\n');

fprintf(f1,'***************************************************\n');
fprintf(f1,'************   Gauss Jordan Method   **************\n');
fprintf(f1,'***************************************************\n\n');


fprintf(f1,'\n\n I in (mA)=\n');
for i=1:RC;
    fprintf(f1,'\t%3.6f\n',C(i,RC+1));
end


fprintf(f1,' \n\n');


%*****************************************************************************  
%*****************************************************************************
%**************************  Calculation body    *****************************
%************************   Gauss seidel Method   ****************************
%*****************************************************************************
fprintf(f1,'***************************************************\n');
fprintf(f1,'****************  Gauss Seidel Method  ************\n');
fprintf(f1,'***************************************************\n\n');
fprintf(f1,'\n\t\t\t All current in(mA)\n\t\t\t====================\n');
fprintf(f1,' k');

for i=1:RC;
    fprintf(f1,'\t\t\tI%1.0f',i);
end
fprintf(f1,'\t\tInfinti Norm');
fprintf(f1,'\n');
for i=1:RC;
    fprintf(f1,'____________________');
end
fprintf(f1,'\n');



%(D+L)X(k+1)=b-U X(k)
state2=1;
k=0;
while state2 >0;%while2 
    k=k+1;
    fprintf(f1,' %1.0f\t\t',k);
    D= diag(diag(R));% determine the diagnoal
    L=tril(R,-1);%determine Lower-Triangular
    U=triu(R,1);%determine Upper-Triangular
    DL=D+L;
    Ux=U*ig;
    xig= inv(DL)*(V-Ux);%ansswer
    fprintf(f1,'%3.6f\t',xig);%print I1 I2 I3 ...
    p(k,:)=xig'; %matrix for plot
    
    ignorm= xig-ig;
    max2=0;
    %determine norm
    for i=1:RC;
        if abs(ignorm(i,1))>max2;
            max2=abs(ignorm(i,1));
            norm=max2;
        end
    end
    p2(k,1)= norm;%matrix for plot
    
    fprintf(f1,'%3.6f\n',norm);
    
%determine Time of itreation
    if norm>tol;
    
        state2=1;
    else
        state2=0;
    end
    ig=xig;
end%while2
for i=1:RC
    p(i,RC+1)=p2(i,1);
end
figure
n=1:k;
stem(n,p,':','filled');
xlabel('k');
ylabel('mA');
title('Gauss Seidel Method');
%print legend
if RC==2;
    h = legend('I1','I2','norm',2);
end
if RC==3;
    h = legend('I1','I2','I3','norm',2);
end
if RC==4;
    h = legend('I1','I2','I3','I4','norm',2);
end
if RC==5;
    h = legend('I1','I2','I3','I4','I5','norm',2);
end
if RC==6;
    h = legend('I1','I2','I3','I4','I5','I6','norm',2);
end
if RC==7;
    h = legend('I1','I2','I3','I4','I5','I6','I7','norm',2);
end
if RC==8;
    h = legend('I1','I2','I3','I4','I5','I6','I7','I8','norm',2);
end
if RC==9;
    h = legend('I1','I2','I3','I4','I5','I6','I7','I8','I9','norm',2);
end
if RC==10;
    h = legend('I1','I2','I3','I4','I5','I6','I7','I8','I9','I10','norm',2);
end

fprintf(f1,'\n\n');
%*****************************************************************************  
%*****************************************************************************
%**************************  Calculation body    *****************************
%*******************   Successive Relaxation Method   ************************
%*****************************************************************************
%B=inv(D+alphaL){(1-alpha)*D-alpha*U}
%Xk+1=Bk+C

fprintf(f1,'***************************************************\n');
fprintf(f1,'********  Successive Relaxation Method   **********\n');
fprintf(f1,'***************************************************\n\n');
fprintf(f1,'\n\t\t\t All current in(mA)\n\t\t\t====================\n');
fprintf(f1,' k');

for i=1:RC;
    fprintf(f1,'\t\t\tI%1.0f',i);
end
fprintf(f1,'\t\tIinitial Norm');
fprintf(f1,'\n');
for i=1:RC;
    fprintf(f1,'____________________');
end
fprintf(f1,'\n');

%calculation:
alphaL=alpha*L;
inv=inv(D+alphaL);
prak=(((1-alpha)*D)-(alpha*U));
B=inv*prak;
c=(alpha*inv)*V;
isr=igprint;
state3=1;
k2=0;


while state3>0;%while3
    k2=k2+1;
    fprintf(f1,' %1.0f\t\t',k2);
    %frist initial cond
    xisr=(B*isr)+c;%Xk+1
    
    
    p3(k2,:)=xisr'; %matrix for plot
    fprintf(f1,'%3.6f\t%0.6f\t%0.6f\t',xisr);
    isrnorm=xisr-isr;
    %determine norm
    max3=0;
    for i=1:RC;
        if abs(isrnorm(i,1))>max3;
            max3=abs(isrnorm(i,1));
            
        end
    end
    
    p4(k2,1)= max3;%matrix for plot
    fprintf(f1,'%3.6f\n',max3);
    if max3 >tol;
        state3=1;
    else
        state3=0;
    end
    isr=xisr;
end%while3
for i=1:RC
    p3(i,RC+1)=p4(i,1);
end

%plot
figure
n=1:k2;
stem(n,p3,':','filled');
xlabel('k');
ylabel('mA');
title('Successive Relaxation Method');
%print legend
if RC==2;
    h = legend('I1','I2','norm',2);
end
if RC==3;
    h = legend('I1','I2','I3','norm',2);
end
if RC==4;
    h = legend('I1','I2','I3','I4','norm',2);
end
if RC==5;
    h = legend('I1','I2','I3','I4','I5','norm',2);
end
if RC==6;
    h = legend('I1','I2','I3','I4','I5','I6','norm',2);
end
if RC==7;
    h = legend('I1','I2','I3','I4','I5','I6','I7','norm',2);
end
if RC==8;
    h = legend('I1','I2','I3','I4','I5','I6','I7','I8','norm',2);
end
if RC==9;
    h = legend('I1','I2','I3','I4','I5','I6','I7','I8','I9','norm',2);
end
if RC==10;
    h = legend('I1','I2','I3','I4','I5','I6','I7','I8','I9','I10','norm',2);
end




        

fclose (f1);
state =input ('continue=1   END=0):');
end%while 1
disp(' ');
disp('              ***************');
disp('              ***   END   ***');
disp('              ***************');