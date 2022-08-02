echo on
s=dir('cap4*.m')
nome={s.name};
n=length(nome);
for i=1:n
    n1=string(nome{i});
    n2=strrep(n1,'cap4','cap5');
    str=['!ren ' n1 ' ' n2];
    eval(str);
end
