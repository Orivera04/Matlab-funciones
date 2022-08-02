function ejecutar(n1,n2,sel,res)
op1=str2num(get(n1,'String'));
op2=str2num(get(n2,'String'));
opera=get(sel,'Value');
switch opera
    case 1
        result=op1+op2;
    case 2
        result=op1-op2;
    case 3
        result=op1*op2;
    case 4
        result=op1/op2;
end
set(res,'String',result);