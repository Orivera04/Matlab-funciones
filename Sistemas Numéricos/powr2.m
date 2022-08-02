function gou=powr2(b);

% This function calculates the power of 2 with the input as the exponent.
%  Class of both variables-gou and b are "char".
if(b==0)
gou='1';
end
if(b==1)
gou='2';
end
if(b==2)
gou='4';
end

a=2;
%==========================================================================
c=[];
for(x=1:b)
    c=[c 0];
end
%==========================================================================
num(1)=a*a;
count2=1;
check2=10;
while 1
check=a/check2;
if(check<1)
    len=count2;
    break,end
count2=count2+1;
check2=check2*10;
end
expo=power(10,len);

c(1)=num(1)-floor(num(1)/expo)*expo;
c(2)=floor(num(1)/expo);
%==========================================================================
if(b>2)
d=[0 0];
for(k=1:b)
num(1)=c(k)*a+d(2);
d(1)=num(1)-floor(num(1)/expo)*expo;
d(2)=floor(num(1)/expo);
got(k)=d(1);
end
%==========================================================================
for(count=1:b-3)
c=got;
for(k=1:b)
num(1)=c(k)*a+d(2);
d(1)=num(1)-floor(num(1)/expo)*expo;
d(2)=floor(num(1)/expo);
got(k)=d(1);
end
end

got=fliplr(got);
%==========================================================================
boss=1;
if(got(1)==0)
    count3=0;
        for(j=2:length(got))
           if(got(j)~=0)
               boss=j;
               break,
           end           
            count3=count3+1;
        end  
end
for(i=1:length(got)-boss+1)
    jad(i)=got(i+boss-1);
end
%==========================================================================
expo1=power(10,len-1);
gou=[];

for(j=1:length(jad))
    fiop=num2str(jad(j));
    if((jad(j)/expo1)<1&&j~=1)
        want=len-length(fiop);
        zor=[];
for(k=1:want)
    zor=[zor '0'];
end
        gou=[gou zor fiop];
    end
    if((jad(j)/expo1)>=1||j==1)
        
gou=[gou fiop];
end
end
end
%==========================================================================