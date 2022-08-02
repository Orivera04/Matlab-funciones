% cap6_uigetfile_exemplo
tipos={'*.jpg'; '*.bmp'}; % *.jpg *.bmp
titulo='Escolha arquivo'; % Titulo
default='NGJuly2002';  % default
diretorio=uigetdir('c:\matlab7\work',titulo)
[nome,caminho]=uigetfile(tipos,titulo,default)
[nome,caminho]=uiputfile(tipos,titulo,default)