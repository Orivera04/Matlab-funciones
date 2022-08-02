% cap4_fwrite_exemplo( m, arquivo )
% Grava matriz m em arquivo com formato binario
function cap4_fwrite_exemplo(m, arquivo)
fid=fopen(arquivo,'w'); % Abre arquivo para gravacao
fwrite(fid,m,'real*8'); % Grava com precisao dupla
fclose(fid);
