%           Progetto Metodo di Simpson
%                 a schema globale
%
%             Programma elaborato da
%
%      Giovanni DI CECCA & Virginia BELLINO
%           50 / 887           408 / 466
%
%             http://www.dicecca.net

% Funzione ausiliaria di simglobal

function [E,approx,xl,xh,k]=MaxList(list,c)

% Salva i valori alla testa della struttura
E=getfield(list(1),'est');

approx=getfield(list(1),'approx');

xl=getfield(list(1),'xl');

xh=getfield(list(1),'xh');

k=1;

% Ricerca dei dati relativi all'intervallo con errore massimo
for (j=2:1:c)
    
    % Confronta la testa della lista con gli
    % altri valori
    if (E<getfield(list(j),'est'))
        
        E=getfield(list(j),'est');
        
        approx=getfield(list(j),'approx');
        
        xl=getfield(list(j),'xl');
        
        xh=getfield(list(j),'xh');

        % Indica la posizione nella list adell'intervallo 
        % con il massimo errore
        k=j; 
        
    end % End if
    
end % end for
