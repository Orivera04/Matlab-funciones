%Elementos de la elipse: se da la ecuación canónica de la elipse 
%y se pide hallar eje mayor, eje menor, diámetro mayor, diámetro menor,
%focos y vértices 

%Introducir la ecuación de la elipse como una cadena de caracteres
ecua=input('Dé la ecuación de la elipse en la forma: x^2/a^2+y^2/b^2 =1:' );
ec=sym(ecua);
disp('ecuación en notación normal:');
pretty(ec)
n=numel(ecua);
indx=findstr(ecua,'x');
ind1=indx+4;
indy=findstr(ecua,'y');
ind2=indy-2;
ind3=indy+4;
ind4=n-2;
den1=ecua([ind1:ind2]);
den2=ecua([ind3:ind4]);
acuad=str2num(den1);
bcuad=str2num(den2);
a=sqrt(acuad);
b=sqrt(bcuad);
if a>b
    c=sqrt(acuad-bcuad);
    disp('El eje mayor es X');
    fprintf('El diámetro mayor es D=%f\n',2*a);
    fprintf('El diámetro menor es d=%f\n',2*b);
    fprintf('La distancia focal es f=%f\n',2*c);
    disp(['Los focos de la elipse son: (',num2str(-c),', 0), ',' (',num2str(c),', 0)']);
    disp(['Los vértices de la elipse son: (',num2str(-a),', 0), ',' (',num2str(a),', 0)']);
else
    c=sqrt(bcuad-acuad);
    disp('El eje mayor es Y');
    fprintf('El diámetro mayor es D=%f\n',2*b);
    fprintf('El diámetro menor es d=%f\n',2*a);
    fprintf('La distancia focal es f=%f\n',2*c);
    disp(['Los focos de la elipse son: (',num2str(-c),', 0), ','(',num2str(c),', 0)']);
    disp(['Los vértices de la elipse son: (',num2str(-b),', 0), ','(',num2str(b),', 0)']);
end
    




