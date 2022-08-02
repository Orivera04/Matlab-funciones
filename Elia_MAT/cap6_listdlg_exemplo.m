% cap6_listdlg_exemplo
function cap6_listdlg_exemplo( )
djpg=dir('*.jpg');    % Struct contendo os arquivos *.jpg
jpgnames={djpg.name}; % Nomes do arquivo 
[sel,ok] = listdlg ( ...
    'ListString', jpgnames, ... % Lista de opcoes
    'ListSize',[160 100], ...      % Tamanho da lista
    'InitialValue', 1, ...      % Primeira opcao
    'Name','Arquivos JPG', ...  % Titulo da caixa de dialogo
    'PromptString','JPG no diretorio corrente', ... % Prompt
    'OKString', 'Exibir', ...      % Tecla OK
    'CancelString', 'Cancela', ... % Tecla Cancel
    'SelectionMode', 'single');    % Modo de selecao 
if ok == 1  % Verifica retorno OK
    a=imread(jpgnames{sel}); % Exibe a imagem
    figure;
    image(a);
end 