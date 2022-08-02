function val=logpost1(T,data)

n=sum(data); y=data(1);
val = y*T-n*log(1+exp(T))-log(1+T.^2);
