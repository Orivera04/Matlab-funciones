function ex_flops

s1   = testflops(2)
s10  = testflops(10)
s100 = testflops(100)

function s = testflops(n)
a = rand(n);
flops(0); b = a+a;               s(1)=flops;   
flops(0); [l u p]  = lu(a);      s(2)=flops;
flops(0); m = a*a;               s(3)=flops; 
flops(0); [u v w]  = svd(a);     s(4)=flops;  
flops(0); expm(a);               s(5)=flops; 
flops(0); pinv(a);               s(6)=flops;
flops(0); [vp va] = eig(a);      s(7)=flops;