warning('j''affiche ce message');
warning off
warning('je n''affiche pas ce message');
try
  clear all
  a
catch
  disp('zut encore une variable indéfinie');
end;
disp('voici la dernière erreur');
disp(lasterr)
disp('Réessayons sans précautions');
b
