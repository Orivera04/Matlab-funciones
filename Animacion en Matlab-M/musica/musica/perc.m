function y1=perc(N,n,fm)
N=[N ' '];
%n=2/5;
i=1;
ii=1;
while i <= length(N)
    if N(i)==' '
        i=i+1;
    end
    switch N(i)
        case '1'
            if N(i+2) == 's'
                h=n/4;
                hh=0;
                i=i+3; 
            elseif  N(i+1) == '6'
                h=n/4;
                i=i+2;  
                hh=1;
            elseif N(i+1) == 's'
                h=4*n;
                hh=0;
                i=i+2; 
            elseif N(i+1) == ' '
                h=4*n;
                i=i+1;
                hh=1;
            end
        case '2'
            if N(i+1) == 's'
                h=2*n;
                i=i+2;
                hh=0;
            else
                h=2*n;       
                i=i+1;
                hh=1;
            end
        case '4'
            if N(i+1) == 's'
                h=n;
                i=i+2;
                hh=0;
            else
                h=n;       
                i=i+1;
                hh=1;
            end
        case '8'
            if N(i+1) == 's'
                h=n/2;
                i=i+2;
                hh=0;
            else
                h=n/2;       
                i=i+1;
                hh=1;
            end
        end
    N1(ii,1)=h;
    N1(ii,2)=hh;
    ii=ii+1;      
    if i==length(N)
        break
    end
end
x=[];
y1=[];
[A,C]=size(N1);

for i=1:A
    t=N1(i,1);
    o=N1(i,2);
 %    x=0:(1/8192):t/2;
%      x=0:(1/fm):t/2;
%      y1=[y1,o*sin(100000*2*pi.*x.*100000000000000.*sin(x)),zeros(size(x))];
    x=(0:(1/fm):t*4/10);
      y1=[y1,o*sin(100000*2*pi.*x.*100000000000000.*sin(x)) zeros(size((0:(1/fm):t*6/10)))];

end
y1=y1/2;