function [dd] = diffdiv(m,k,y0,y)
for i=1:m
    dd(1,i)=y0(i);
    for j=1:k
        dd(j+1,i)=y(i,j);
    end
    for j=2:k+1
        dt = (j-1);
        for l=k+1:-1:j
            dd(l,i)=(dd(l,i)-dd(l-1,i))/dt;
        end
    end
end