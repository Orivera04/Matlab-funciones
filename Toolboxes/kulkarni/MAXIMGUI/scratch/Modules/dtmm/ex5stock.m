function P = ex5stock(L,U);

%Output:  P = tr pr matrix for the stockmarket example.
%Usage:   L = lower support value;
%         U = upper support value;

d = U-L+1;
P = zeros(d,d);
P = .2*(diag(ones(d,1),0)+diag(ones(d-1,1),-1)+diag(ones(d-2,1),-2)+diag(ones(d-1,1),1)+diag(ones(d-2,1),2)) ;
P(1:2,1) = [.6 .4]';
P(d-1:d,d) = [.4 .6]';
