warning('j''affiche ce message');
warning off
warning('je n''affiche pas ce message');
try
  clear all
  a
catch
  disp('zut encore une variable ind�finie');
end;
disp('voici la derni�re erreur');
disp(lasterr)
disp('R�essayons sans pr�cautions');
b
