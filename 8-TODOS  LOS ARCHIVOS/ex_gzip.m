% Copie tous les m fichiers du r�pertoire courant vers le
% r�pertoire 'sauvegarde'
tar('mes_mfichiers.tar.gz','*.m');
untar('mes_mfichiers','sauvegarde');

% <<d�tar>> et liste les exemples de programmation 
% MATLAB de C. Moler vers le r�pertoire 'ncm'.
url ='http://www.mathworks.com/moler/ncm.tar.gz';
ncmFiles = untar(url,'ncm')
 
