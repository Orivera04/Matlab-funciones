function  c=tpy(i,dty,hang,cot,I);
                j=1;
                b=[1:cot];    
                for x=1:cot
                    y=round((x*(hang - 2*i*dty))/cot + i*dty);
                    if y == 0
                        continue;
                     end
                    if (I(y,x)==0)
                        b(j)=1;
                        j=j+1;
                    elseif (I(y,x)==1)
                        b(j)=0;
                        j=j+1;
                    end
                end
                c=b;