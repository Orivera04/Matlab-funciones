function c =ex5telcost(K,a,rt,cl);
%K = capacity of the buffer.
%a = pmf of the arrivals in one time slot,
%rt = revenue from transmitting one packet;
%cl = cost of losing one packet;
%c(i) = expected net cost, (cost of packet loss - revenue from
%packet transmission) in
%the (n+1)st slot if there are i packets in the buffer
%at the end of the nth slot.
if  K < 0 | fix(K) - K ~= 0
msgbox('invalid entry for K');c='error';return;
elseif  any(a < 0) | abs(sum(a)-1.0)>10^(-4)
msgbox('invalid entry for a');c='error';return;
else
   c=zeros(K+1,1);
   [ma na]=size(a);
   if ma > 1
      msgbox('a must be  a row vector'); c='error'; return;
   end;
   for r=K:na-1
      c(1,1)=c(1,1)+(r-K)*a(r+1);
   end;
   c(1,1)=cl*c(1,1);
   for i=1:K
      for r=K+1-i:na-1
         c(i+1,1)=c(i+1,1)+(r-K-1+i)*a(r+1);
      end;
      c(i+1,1) = cl*c(i+1,1) - rt;
   end;
end;
      
 