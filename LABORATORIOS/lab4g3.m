%ejercicio numero 3, adivina elnumero.
%integrantes: Maria Elena Gonzalez Jimenez.
%             Rafael Antonio Guevara.
%laboratorio num 4, grupo num 3.
clc;
i=2;
while(i==2)
    fprintf('\t\t JUEGO\"ADIVINA UN NUMERO\"\n');
    x=input('de un numero a adivinar: ');
    j=1;
    s=0;
    b=0;
    a=0;
    clc;
    while(j==1)
        y=input('adivina el numero: ');
        s=s+1;
        if(y==x)
            fprintf('...................ACERTASTES........................\n');
            fprintf('...................FELICIDADES.........................');
            j=2;
        else if(y>x)
            fprintf('DEMASIADO ALTO\n');
            b=b+1;
            j=1;
        else
            fprintf('DEMASIADO BAJO\n');
            a=a+1;
            j=1;
        end;
    end;
end;
fprintf('\n\n LOS NUMEROS DE INTENTOS SON: %d\n',s);
fprintf('\nUSTED TUVO: %d, NUMEROS DEMASIADO ALTOS.\n',b);
fprintf('\nUSTED TUVO: %d, NUMEROS DEMASIADO BAJOS.\n',a);
i=input(' \nDESEA SALIR DEL PROGRAMA: S(1)/N(2) ');
exit;
end




       
        
    
           
        
 