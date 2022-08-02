% P9_4.M  Compute DFT of discrete pulse
%
clear
N=10;
ft=[1 1 1 1 1 0 0 0 0 0 ];
Ff=zeros(1,N);
for k=1:N;
	for n=1:N;
   	Ff(k)=Ff(k)+ft(n)*exp(-2*i*pi*(n-1)*(k-1)/N) ; 
	end
	 if (abs(imag(Ff(k)))<=10*eps)&(abs(real(Ff(k)))<=10*eps)
    	 Ff(k) = 0;
    	 end	    
end
% Index from 0 to N
f=[0:N];
Ff(N+1)=Ff(1);	% Periodic
Fmat=[f;Ff]';
disp(Fmat)
Ffr=abs(Ff);
Ffi=(180/pi)*angle(Ff);
subplot(2,1,1),stem(f,Ffr)
subplot(2,1,2),stem(f,Ffi)

