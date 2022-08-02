% cap4_avi_exemplo ( )
% Cria uma animacao: uma espiral 3D
function mov=cap4_avi_exemplo(inic,fim)
ind=1;
figure('visible','off');
for i=inic:fim
    surf(peaks(i));  % Gera superficie
    axis([0 fim 0 fim -10 10])
    mov(ind)=getframe;
    ind=ind+1;
end
% Grava arquivo
 movie2avi(mov,'cap3_avi_exemplo.avi','COMPRESSION','None')

