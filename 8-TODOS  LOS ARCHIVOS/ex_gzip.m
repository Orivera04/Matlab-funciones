% Copie tous les m fichiers du répertoire courant vers le
% répertoire 'sauvegarde'
tar('mes_mfichiers.tar.gz','*.m');
untar('mes_mfichiers','sauvegarde');

% <<détar>> et liste les exemples de programmation 
% MATLAB de C. Moler vers le répertoire 'ncm'.
url ='http://www.mathworks.com/moler/ncm.tar.gz';
ncmFiles = untar(url,'ncm')
 
