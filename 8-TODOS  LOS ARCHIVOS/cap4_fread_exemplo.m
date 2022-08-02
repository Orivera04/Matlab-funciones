% cap4_fread_exemplo( arquivo )
% Le matriz m do arquivo com formato binario
function m=cap3_fwrite_exemplo(arquivo)
fid=fopen(arquivo,'r'); % Abre arquivo para leitura
m=fread(fid,'real*8'); % Lê com precisao dupla
fclose(fid);
