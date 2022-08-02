function evaluar(f)
cadena=get(f,'string');
error=0;
nufila=size(cadena,1);
for i=1:nufila,
   eval(cadena(i,:),'error=1;');
   if error,break;end;
end;
