function val=logpost2(xy,data)

t1=xy(:,1);   t2=xy(:,2);
y1=data(1); n1=data(2); y2=data(3); n2=data(4); 
sd=data(5);

g1=(t1+t2)/2; g2=(t2-t1)/2;

val=y1*g1-n1*log(1+exp(g1))+y2*g2-n2*log(1+exp(g2));

val=val+log(pdfnorm(t1,0,sd));

function val=pdfnorm(x,mu,sigma)

if nargin==1, mu=0; sigma=1; end

val=1/sqrt(2*pi)./sigma.*exp(-.5./sigma.^2.*(x-mu).^2);



