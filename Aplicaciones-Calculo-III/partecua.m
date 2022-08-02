function partecua()
%Ecuación A1x1+C=0
f=input('ecuación: ');
num=numel(f);
ind1=findstr(f,'x')-1;
ind2=ind1+2;
f1=f([1:ind1]);
f2=f(ind2:num-2);
disp('coeficientes:');
disp(['A1=',f1,'  C=',f2]);
se='=0';
ecuacion=strcat(f1,'x',f2,se)