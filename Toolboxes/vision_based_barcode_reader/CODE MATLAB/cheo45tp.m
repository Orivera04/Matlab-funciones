function c=cheo45tp(dt,hang,cot,I);
if (dt<=hang)
        j=1;
        b=[1:dt];    
        for x=1:(dt-1)
            y=dt - x;
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
        b=[(dt-hang):dt];    
        for x=(dt-hang):(dt-1)
            if x==dt
                continue;
            end
            y=dt - x;
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
        b=[(dt-hang):cot];    
        for x=(dt-hang):cot
            y=dt - x;
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