%find_lcr computes the LCR of NSamples of magnitude Z for different threshold values
%input parameters: Z        - magnitude
%                  NSamples - the number of samples
%                  Ts       - Sampling Interval
%                  std_r    - standard deviation for Z 
%outputs:          AFD      - level crossing rate
%                  Rn       - normalized threshold p(dB)
%                  R        - threshold

function [AFD, Rn, R] = find_afd(Z, NSamples, Ts, std_r)
min = -10;
max = 10;
N = 100;
delta = (max - min) / N;
for k=1:N
   Mt = 0;
   Rn(k) = min + k * delta;
   R(k) = 10^(Rn(k)/20)*sqrt(2)*std_r;
   %if the first point is less than the threshold , start off with 1 else start off
   %with 0.  This is necessary since the previous point is needed to determine if a 
   %positive crossing is observed.  
   if (Z(1) < Rn(k))
      AFD(k) = 1;
   else
      AFD(k) = 0;
   end

   %starting from the second sample on, count the number of positive crossings and
   %count the number of samples that is below the threshold.
   for j=2:NSamples
      if Z(j) > R(k) & Z(j-1) <= R(k)
         Mt = Mt + 1;
      end
      if (Z(j) < R(k))
         AFD(k) = AFD(k) + 1;
      end
      
   end
   if(Mt == 0)
      Mt = 1;
   end
   AFD(k) = AFD(k)*Ts/1000/Mt;
   
end

return;
