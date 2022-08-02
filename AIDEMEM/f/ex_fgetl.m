function ex_fgetl

strs = rdtxt('ex_fgetl.m');
for i = 1:length(strs)
  fprintf('%s\n', strs{i});
end;

function strs = rdtxt(name)
% lecture d'un texte dans un tableau cellulaire
f = fopen(name);
i=1;
while ~feof(f)
  strs{i}=fgetl(f);
  i=i+1;
end;  
fclose(f);    