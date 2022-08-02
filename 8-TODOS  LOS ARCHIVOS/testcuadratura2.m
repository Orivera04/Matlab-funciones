% Este programa forma parte del material auxiliar del texto
%
%   "Matlab en cinco lecciones de numerico"
%    por V. Dominguez y M.L. Rapun.
%
% Se permite la libre copia, distribucion y ejecucion con la 
% unica condicion de mencionar y el origen y autores.
%
% Mas informacion en
%
%   http://www.unavarra.es/personal/victor_dominguez

f=vectorize(inline('exp(-x)*(2+cos(7*x))'));
% Extremos del intervalo de integracion
a=-2; b=2;
% Integral exacta (requiere la toolbox de simbolico
syms x
intex=double(int(f(x),'x',a,b));
% Parametros de los experimentos
% nexp='numeros de experimentos'
% n0= numero de puntos de primera regla
%     sucesivas reglas duplican el número de puntos.
%
n0=12; nexp=8;

% Comenzamos el experimento
intTrap=zeros(1,nexp);
intMedio=intTrap;intSimpson=intTrap;int3Octavos=intTrap;
intNewCot5ptos=intTrap;
for j=1:nexp
    n=2^(j-1)*n0;
    intTrap(j)=trapecio(f,a,b,n);
    intMedio(j)=puntomedio(f,a,b,n);
    intSimpson(j)=simpson(f,a,b,n);
    int3Octavos(j)=regla3Octavos(f,a,b,n);
    intNewCot5ptos(j)=NewCotCerrada5ptos(f,a,b,n);
end

% Desplegamos resultados
format short e
disp(['integral exacta= ' num2str(intex)])
disp(' ')
disp('Errores')
disp(' ')
errorTrap=intTrap-intex;
errorPuntoMedio=intMedio-intex;
errorSimp=  intSimpson-intex;
errorregla3Octavos=int3Octavos-intex;
errorNewCot=intNewCot5ptos-intex;
fprintf('Puntos    Pto medio    Trapecio    Simpson         3/8        NwCt 5ptos\n')
for j=1:nexp
     fprintf('%5d   %+9.3e  %+5.3e  %+5.3e  %+5.3e  %+5.3e  \n',n0*2^(j-1),...
        errorPuntoMedio(j),errorTrap(j), errorSimp(j),...
        errorregla3Octavos(j),errorNewCot(j))
end
disp(' ')
disp('ratio')
disp(' ')
fprintf('Pto medio    Trapecio     Simpson      3/8      NwCt 5ptos\n')
for j=1:nexp-1
    fprintf('%7.3f  %11.3f  %10.3f  %10.3f %10.3f\n',...
        errorPuntoMedio(j)/errorPuntoMedio(j+1),...
        errorTrap(j)/errorTrap(j+1),...
        errorSimp(j)/ errorSimp(j+1),...
        errorregla3Octavos(j)/errorregla3Octavos(j+1),...
        errorNewCot(j)/errorNewCot(j+1))
end
semilogy(1:nexp,abs(errorPuntoMedio),'o:',...
    1:nexp,abs(errorTrap),'o:',1:nexp,abs(errorSimp),'o:',...
    1:nexp,abs(errorregla3Octavos),'o:',1:nexp,abs(errorNewCot),'o:')
legend('Punto Medio', 'Trapecio', 'Simpson','Regla 3/8','NC cerrrada 5ptos')
format short
    