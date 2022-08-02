% circuito_calculo : calcula correntes e potencia total do circuito
function circuito_calculo ( )
% Obtem os valores da tela de interface criada no GUIDE
obj  = findobj(gcf,'Tag','V1');         % Paramentro V1
V1 = str2double(get(obj,'String'));
obj  = findobj(gcf,'Tag','V2');         % Paramentro V2
V2 = str2double(get(obj,'String'));
obj  = findobj(gcf,'Tag','R1');         % Paramentro R1
R1 = str2double(get(obj,'String'));
obj  = findobj(gcf,'Tag','R2');         % Paramentro R2
R2 = str2double(get(obj,'String'));
obj  = findobj(gcf,'Tag','R3');         % Paramentro R3
R3 = str2double(get(obj,'String'));
obj  = findobj(gcf,'Tag','R4');         % Paramentro R4
R4 = str2double(get(obj,'String'));
obj  = findobj(gcf,'Tag','R5');         % Paramentro R5
R5 = str2double(get(obj,'String'));

% Executa calculo (o mesmo codificado em circuito01.m)
A = [ (R1+R4) -R4        0       ; ... % (R1+R4)*I1 - R4 * I2         
      -R4     (R4+R2+R5) -R5     ; ... %   -R4 * I1 + (R4+R2+R5)*I2 - R5 * I3
       0      -R5        (R5+R3)];     %            - R5 * I2        + (R5+R3)*I3     

V = [ V1; ...% (R1+R4)*I1 - R4 * I2                     = V1  
      0; ... %   -R4 * I1 + (R4+R2+R5)*I2 - R5 * I3     = 0   
     -V2];   %            - R5 * I2        + (R5+R3)*I3 = -V2

% Verifica determinante de A
DA = det(A);
if abs(DA) < eps
    ValI1='-';
    ValI2='-';
    ValI3='-';
    ValPT='Nao ha solucao';
else
    i123=A\V;     % Vetor contento as tres correntes
    potencia = V1 * i123(1) - V2 * i123(3); % Potencia total
    ValI1=num2str(i123(1),3);
    ValI2=num2str(i123(2),3);
    ValI3=num2str(i123(3),3);
    ValPT=num2str(potencia,5);
end

% Exibe resultados na tela GUIDE
obj  = findobj(gcf,'Tag','I1');
set(obj,'String',ValI1);
obj  = findobj(gcf,'Tag','I2');
set(obj,'String',ValI2);
obj  = findobj(gcf,'Tag','I3');
set(obj,'String',ValI3);
obj  = findobj(gcf,'Tag','PT');
set(obj,'String',ValPT);