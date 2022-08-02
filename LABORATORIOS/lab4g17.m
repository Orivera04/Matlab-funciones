clc;
i=1;
st=0;
while(i~=0);
    importe=1;
    s=1;
    s=0;
    clc,
    while(importe~=0);
        importe=input ('De el importe:');
        s=s+importe;
    end;
    if( s >=5000)||(s<=12000)
        des=s*0.15;
        total=s-des;
        st = st+ total;
        fprintf('\nEl importe total a pagar es %.2f\n\n',total);
    elseif(s >12000);
        des=s*0.2;
        total=s-des;
        st= st + total;
        fprintf('\nEl importe total a pagar es %.2f\n\n',total);
    end;
    i=input('Mas clientes si(1)  no(2)');
    if(i~=1)
        i=0;
    end;
end;
fprintf('\n\nLa suma total de importes cobrados es %.2f',st);