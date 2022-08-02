% updown2.m
% up-down algorithm

Nums = 25:50;  % numbers to test
for i=1:length(Nums)
   N=Nums(i);  % number to test
   count = 0;  % iteration count
	while N>1
       if rem(N,2)==0 % even
          N=N/2;
          count=count+1;
       else           % odd
          N=(3*N+1)/2;
          count=count+2;
       end
	end
	Counts(i)=count;
end
results=[Nums' Counts']