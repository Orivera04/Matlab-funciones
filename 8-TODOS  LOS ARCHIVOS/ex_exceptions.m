try
  n=input('nom de fichier svp : ','s');
  f= fopen(n,'r');
  a=fread(f);
  fprintf('votre fichier existe bien\n');
  fclose(f);
catch
  fprintf('Votre fichier << %s >> n''existe pas\n', n);
  fprintf('%s\n',lasterr);
end;
fprintf('bye\n');
