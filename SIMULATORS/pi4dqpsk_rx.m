function [a] = pi4dqpsk_rx(Rn, N)
%receiver
   temp(1) = Rn(1);
   for k= 1:N/2-1
      temp(k+1) = Rn(k+1)*conj(Rn(k));
   end
   for k = 1:N/2
      if (imag(temp(k))< 0)
         a(2*k-1) = 1;
      else
         a(2*k-1) = 0;
      end
      if (real(temp(k))<0)
         a(2*k) = 1;
      else
         a(2*k) = 0;
      end
   end
return;
