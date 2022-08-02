% cap4_image_exemplo (entrada,saida)
function cap4_image_exemplo(entrada,saida)
rgb=imread(entrada);
image(rgb)
title('Imagem Original')
figure
subplot(2,2,1)
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
imwrite(rgb1,saida); % Grava arquivo da imagem com cores invertidas
