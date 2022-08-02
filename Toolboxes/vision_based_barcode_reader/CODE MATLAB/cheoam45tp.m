function c=cheoam45tp(dt,hang,cot,I);
    if (dt<=hang)
        j=1;
        b=[1:dt];    
        for y=1:dt
            x=y+cot-dt;
            if (I(y,x)==0)
                b(j)=1;
                j=j+1;
            elseif (I(y,x)==1)
                b(j)=0;
                j=j+1;
            end
        end
    elseif (dt>hang) & (dt<cot)
        j=1;
        b=[1:hang];    
        for y=1:hang
            
            x=y+cot-dt;
            
            if (I(y,x)==0)
                b(j)=1;
                j=j+1;
            elseif (I(y,x)==1)
                b(j)=0;
                j=j+1;
            end
        end
    elseif (dt>cot)
        j=1;
        b=[(dt-cot):hang];    
        for y=(dt-cot+1):hang
            x=y+cot-dt;
            if (I(y,x)==0)
                b(j)=1;
                j=j+1;
            elseif (I(y,x)==1)
                b(j)=0;
                j=j+1;
            end
        end
      end

    c=b;