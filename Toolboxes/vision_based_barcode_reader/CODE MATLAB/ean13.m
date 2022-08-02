function result=ean13(p,k)
        doc1=[1:6];
        h=1;
        for i=(k+3):4:(k+23)
            if (p(i)==3)& (p(i+1)==2) &(p(i+2)==1) &(p(i+3)==1)
                doc1(h)=0;
            elseif (p(i)==2)& (p(i+1)==2) &(p(i+2)==2) &(p(i+3)==1)
                doc1(h)=1;  
            elseif (p(i)==2)& (p(i+1)==1) &(p(i+2)==2) &(p(i+3)==2)
                doc1(h)=2;
            elseif (p(i)==1)& (p(i+1)==4) &(p(i+2)==1) &(p(i+3)==1)
                doc1(h)=3;
            elseif (p(i)==1)& (p(i+1)==1) &(p(i+2)==3) &(p(i+3)==2)
                doc1(h)=4;
            elseif (p(i)==1)& (p(i+1)==2) &(p(i+2)==3) &(p(i+3)==1)
                doc1(h)=5;
            elseif (p(i)==1)& (p(i+1)==1) &(p(i+2)==1) &(p(i+3)==4)
                doc1(h)=6;
            elseif (p(i)==1)& (p(i+1)==3) &(p(i+2)==1) &(p(i+3)==2)
                doc1(h)=7;
            elseif (p(i)==1)& (p(i+1)==2) &(p(i+2)==1) &(p(i+3)==3)
                doc1(h)=8;
            elseif (p(i)==3)& (p(i+1)==1) &(p(i+2)==1) &(p(i+3)==2)
                doc1(h)=9;
            end
            h=h+1;
        end
        doc2=[1:6];
        h=1;
        for i=(k+32):4:(k+52)
            if (p(i)==3)& (p(i+1)==2) &(p(i+2)==1) &(p(i+3)==1)
                doc2(h)=0;
            elseif (p(i)==2)& (p(i+1)==2) &(p(i+2)==2) &(p(i+3)==1)
                doc2(h)=1;  
            elseif (p(i)==2)& (p(i+1)==1) &(p(i+2)==2) &(p(i+3)==2)
                doc2(h)=2;
            elseif (p(i)==1)& (p(i+1)==4) &(p(i+2)==1) &(p(i+3)==1)
                doc2(h)=3;
            elseif (p(i)==1)& (p(i+1)==1) &(p(i+2)==3) &(p(i+3)==2)
                doc2(h)=4;
            elseif (p(i)==1)& (p(i+1)==2) &(p(i+2)==3) &(p(i+3)==1)
                doc2(h)=5;
            elseif (p(i)==1)& (p(i+1)==1) &(p(i+2)==1) &(p(i+3)==4)
                doc2(h)=6;
            elseif (p(i)==1)& (p(i+1)==3) &(p(i+2)==1) &(p(i+3)==2)
                doc2(h)=7;
            elseif (p(i)==1)& (p(i+1)==2) &(p(i+2)==1) &(p(i+3)==3)
                doc2(h)=8;
            elseif (p(i)==3)& (p(i+1)==1) &(p(i+2)==1) &(p(i+3)==2)
                doc2(h)=9;
            end
            h=h+1;
        end
        result=[doc1 doc2];