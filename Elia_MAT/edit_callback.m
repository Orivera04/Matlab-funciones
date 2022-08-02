function edit_callback( )
% Verifica se o texto é valor numérico positivo
h=gcf;  % Figura corrente
obj=findobj(h,'Tag','edit1'); % Objeto edit1
str=get(obj,'String');  % Dado digitado
valor=sscanf(str,'%f'); % Tenta obter um numero
switch valor
    case 0
        errordlg('Valor NAO pode ser ZERO');
    case ''
        errordlg('Valor NAO pode ser ALFANUMERICO');
    otherwise
        if valor < 0
            errordlg('Valor NAO pode ser MENOR QUE ZERO');
        else        
            warndlg('VALOR ACEITO!');
        end
end
