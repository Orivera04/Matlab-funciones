function l = flength(nom)

% l = flength(nom) renvoie la taille du fichier de nom nom.

f = fopen(nom,'r');
fseek(f,0,'eof');
l = ftell(f);
fclose(f);