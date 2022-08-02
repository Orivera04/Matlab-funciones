function c=ngangtp(i,linengang,hang,cot,I);
    j=1;
    b=[1:cot];    
    for x=1:cot
        if (I(round(i*(hang/linengang)),x)==0)
            b(j)=1;
            j=j+1;
        elseif (I(round(i*(hang/linengang)),x)==1)
            b(j)=0;
            j=j+1;
        end
    end
    c=b;