E=[212 208 220 200]*1e9; %pascals
A(1)=obeam(0.13, 0.11, 'area'); %meters^2
A(2)=obeam(0.09, 0.07, 'area'); %meters^2
A(3)=obeam(0.05, 0.03, 'area'); %meters^2
A(4)=circle(0.01, 'area'); %meters^2
Alpha=[13 15 14 12]*1e-6;
DeltaT=40;
OriginalL=0.2;
%%%%% End Data Entry %%% Start Matrix Cnstruction
FreeL=OriginalL*(1+(Alpha*DeltaT));

UR=eye(length(E)-1);
UL=-ones(length(E)-1,1);
K=FreeL./(A.*E);

coefs=[UR UL; K];
answ=FreeL(length(FreeL))-FreeL';

deltas=inv(coefs)*answ;

format long %Answer seen to more digits
FinalLength=FreeL'+deltas
format short %Format reset
