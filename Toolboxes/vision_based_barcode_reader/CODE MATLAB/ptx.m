function  c=ptx(i,dtx,hang,cot,I);
          j=1;
          b=[1:hang];    
          for y=hang:-1:1
              x=round((y*(cot - 2*i*dtx))/hang + i*dtx);
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