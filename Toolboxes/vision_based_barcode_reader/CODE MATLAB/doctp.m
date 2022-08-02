function c=doctp(i,linedoc,hang,cot,I);
j=1;
    b=[1:hang];    
    for y=1:hang
        if (I(y,round(i*(cot/linedoc)))==0)
            b(j)=1;
            j=j+1;
        elseif (I(y,round(i*(cot/linedoc)))==1)
            b(j)=0;
            j=j+1;
        end
    end
    c=b;