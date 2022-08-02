% Exercicios Propostos 02
function exercicios_propostos_02 ()
% Matriz
m=[1 1 0; 1 0 1; 0 1 1];
v=[59000 93000 106000]';
r=m\v;
r0(1)=r(1)/1.15; % Valor inicial de Carlos 
r0(2)=r(2)/1.20; % Valor inicial de Luis
r0(3)=(r(3)-25000*1.20); % Valor inicial de Silvio
rend=(r0(3)-25000)/25000; % Rendimento
display({'Valores iniciais';['Carlos: R$' num2str(r0(1))]; ...
    ['Luis: R$ ' num2str(r0(2))]; ['Silvio: R$ ' num2str(r0(3))]});
display(['Rendimento: ' num2str(rend*100) '%']);
