% exercicios_propostos_07
function exercicios_propostos_07 (entrada,saida)
switch nargin
    case 0
        prompt={'Entrada' 'Saida'};
        nome='Nomes dos Arquivos';
        arquivos=inputdlg(prompt,nome);
    case 1
        prompt={'Saida'};
        nome='Nomes dos Arquivos';
        r=inputdlg(prompt,nome);
        arquivos={ entrada r{1} };
    otherwise
        arquivos={ entrada saida };
end

if ~isempty(arquivos)
    if isempty(arquivos{1})
        errordlg('Arquivo de entrada nao fornecido.');
    elseif isempty(arquivos{2})
        errordlg('Arquivo de saida nao fornecido.');
    else
        rgb=imread(arquivos{1});
        image(rgb);
        title('Imagem Original');
        figure;
        subplot(2,2,1);
        image(rgb(:,:,1))
        title('Mapa da Cor Vermelha (RED)')
        subplot(2,2,2)
        image(rgb(:,:,2))
        title('Mapa da Cor Verde(GREEN)')
        subplot(2,2,3)
        image(rgb(:,:,3))
        title('Mapa da Cor Azul(BLUE)')
        subplot(2,2,4)
        rgb1=bitcmp(rgb);  % Bit complementar
        image(rgb1)
        title('Cor complementar')
        imwrite(rgb1,arquivos{2}); % Grava arquivo da imagem com cores invertidas
    end
end
