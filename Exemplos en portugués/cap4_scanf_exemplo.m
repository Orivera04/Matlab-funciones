% cap4_scanf_exemplo( )
% Le arquivo, retorna dados em um vetor 1xN
function m=cap4_fscanf_exemplo(arquivo)
fid=fopen(arquivo,'r'); % Abre arquivo para leitura
m=fscanf(fid,'%f',[1 Inf']); % Le dados
fclose(fid);  % Fecha arquivo
