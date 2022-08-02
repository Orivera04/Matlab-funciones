% Arquivo: cap2_exemplo_14.m
% Exemplo: item 2.5.8 -  nested-function
function m = cap2_exemplo_14 ( n )
m = [n nivel1(n-1)];
    function m1 = nivel1 ( n1 )   % Funcao aninhada 1
        m1 = [n1 nivel2(n-2)];
        function m2 = nivel2 ( n2 )  % Funcao aninhada 2
            m2 = [n2 nivel3(n-3)];
            function m3 = nivel3 ( n3 ) % Funcao aninhada 3
                m3 = [n3 n3-1];
            end
        end
    end
end

