% cap6_waitfor_exemplo
function cap6_waitfor_exemplo ( )
h=surf(peaks);   % Desenha um grafico
waitfor(h)       % Espera que ele seja eliminado
h=msgbox('Grafico anterior eliminado. Pronto para desenhar o proximo');
waitfor(h)       % Espera que ele seja eliminado
plot(rand(1,10)) % Desenha outro grafico
