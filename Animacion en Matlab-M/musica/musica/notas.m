function y1=notas(N,n,fm)
r=2^(1/12);
fr=440;%frecuencia del LA
fr=r^-9*fr;%el Do
c=r^0*fr*[1/4 1/2 1 2 4]; 
cs=r^1*fr*[1/4 1/2 1 2 4];
d=r^2*fr*[1/4 1/2 1 2 4];
ds=r^3*fr*[1/4 1/2 1 2 4];
e=r^4*fr*[1/4 1/2 1 2 4];
f=r^5*fr*[1/4 1/2 1 2 4];
fs=r^6*fr*[1/4 1/2 1 2 4];
g=r^7*fr*[1/4 1/2 1 2 4];
gs=r^8*fr*[1/4 1/2 1 2 4];
a=r^9*fr*[1/4 1/2 1 2 4];
as=r^10*fr*[1/4 1/2 1 2 4];
b=r^11*fr*[1/4 1/2 1 2 4];
s=0;

i=1;
ii=1;
while i <= length(N)
    if N(i)==' '
        i=i+1;
    elseif N(i)=='1' | N(i)=='2' |N(i)=='4' |N(i)=='8'
        switch N(i)
            case '1'
                if  N(i+1) == '6'
                    h=n/4;
                    i=i+2;
                else
                    h=4*n;
                                i=i+1;
                            end
                        case '2'
                            h=2*n;       
                            i=i+1;
                        case '4'
                            h=n;
                            i=i+1;
                        case '8'
                    h=n/2;
                    i=i+1;
            end
        else 
        switch N(i)
            case 'a'
                if N(i+1)=='s'
                    j=as(str2num(N(i+2)));
                    i=i+3;
                else
                    j=a(str2num(N(i+1)));
                    i=i+2;
                end
            case 'b'
                j=b(str2num(N(i+1)));
                i=i+2;
            case 'c'
                if N(i+1)=='s'
                    j=cs(str2num(N(i+2)));
                    i=i+3;
                else
                    j=c(str2num(N(i+1)));
                    i=i+2;
                end                
            case 'd'
                if N(i+1)=='s'
                    j=ds(str2num(N(i+2)));
                    i=i+3;
                else
                    j=d(str2num(N(i+1)));
                    i=i+2;
                end                
            case 'e'
                j=e(str2num(N(i+1)));
                i=i+2;
            case 'f'
                if N(i+1)=='s'
                    j=fs(str2num(N(i+2)));
                    i=i+3;
                else
                    j=f(str2num(N(i+1)));
                    i=i+2;
                end 
            case 'g'
                if N(i+1)=='s'
                    j=gs(str2num(N(i+2)));
                    i=i+3;
                else
                    j=g(str2num(N(i+1)));
                    i=i+2;
                end 
            case 's'
                j=0;
                i=i+1;
        end
        N1(ii,1)=j;
        N1(ii,2)=h;
        ii=ii+1;
    end 
end
x=[];
y1=[];
[A,C]=size(N1);
for i=1:A
     fr=N1(i,1);
     t=N1(i,2);
     %x=(0:(1/8192):t*8/10);
     x=(0:(1/fm):t*8/10);
     y1=[y1  sin(fr*2*pi.*x)+1/4*sin(3*fr*2*pi.*x)+1/6*sin(5*fr*2*pi.*x)+1/8*sin(7*fr*2*pi.*x) zeros(size((0:(1/fm):t*2/10)))];    
 end
