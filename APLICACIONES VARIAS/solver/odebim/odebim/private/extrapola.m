function [ynew] = extrapola(m,k,knew,h0,h,dd)
rath = (h/h0);
for i=1:m
%     evaluation of the interpolating polynomial at the points of the new block
    for l=1:knew
        dt  = (l)*rath;
        ynew(i,l)=dd(k+1,i);
        for j=k:-1:1
            dt = dt+1d0;
            ynew(i,l)=ynew(i,l)*dt +dd(j,i);
        end
    end
end