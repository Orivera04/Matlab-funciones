function zero()
load zero.dat;
x=zero;
%
fprintf('Estadisticas de digito\n\n');
fprintf('media: %f\n',mean(x));
fprintf('desviacion estandar: %f\n',std(x));
fprintf('varianza: %f\n',std(x)^2);
fprintf('potencia media: %f\n',mean(x.^2));
fprintf('magnitud media: %f\n',mean(abs(x)));
prod=x(1:length(x)-1).*x(2:length(x));
crossing=length(find(prod<0));
fprintf('cruces de cero: %.0f\n',crossing);
sound(x);
%subplot(2,1,1),plot(x),...
 %  title('pronunciacion de la palabra zero'),...
  % xlabel('indice'),grid