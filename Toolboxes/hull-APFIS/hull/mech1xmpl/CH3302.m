%%%%% Bookkeeping cleaning up the workspace
clear all
close all
clc

L=10; 
supports=[0 8];
unknowns=[DR(90) supports(1) 0; DR(90) supports(2) 0;0 0 0];
stepsize=0.5; %how finely the data is made
col=0; %column index
for dis=0:stepsize:10 %changing through all the distances
  col=col+1; %incrementing the column index
  row=0; %restarting the row index
  for magni=-5:stepsize:5 %nested loop for magnitude
    row=row+1; %row index
    af=[0 magni dis 0]; %defining load with new data
    reactions=threevector(af,unknowns); %finding reactions
    a(row,col)=mag(reactions(1,:),'y');
    b(row,col)=mag(reactions(2,:),'y');
    Dis(row,col)=dis;
    Magni(row,col)=magni;
  end
end
figure (1)
mesh(Dis,Magni,a)
title ('Reaction at A')
xlabel('Distance to Load')
ylabel('Magnitude of Load')

figure (2)
mesh(Dis,Magni,b)
title ('Reaction at B')
xlabel('Distance to Load')
ylabel('Magnitude of Load')

figure (3)
mesh(Dis,Magni,-(a+b))
title ('Sum of reactions')
xlabel('Distance to Load')
ylabel('Magnitude of Load')

valid=find(a<=4 & a>=3);
% valid=find(a<2*b);
% valid=find(a<-4 | b<-4 | a>3 | b>3);
A=nan*ones(size(a));
A(valid)=a(valid);
figure (4)
mesh (Dis, Magni, A)
title ('A force between 3 and 4')
xlabel('Distance to Load')
ylabel('Magnitude of Load')
view (2)
figure (1)
view (2)
