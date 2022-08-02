%find_lcr computes the LCR of NSamples of magnitude Z for different threshold values
%input parameters: Z        - magnitude
%                  NSamples - the number of samples
%                  T        - Total Time
%                  std_r    - standard deviation for Z 
%outputs:          LCR      - level crossing rate
%                  Rn       - normalized threshold p(dB)
%                  R        - threshold
function [LCR, Rn, R] = find_lcr(Z, NSamples, T, std_r)
min = -10;
max = 10;
N = 100;
delta = (max - min) / N;
for k=1:N
   Mt = 0;
   Rn(k) = min + k * delta;
   R(k) = 10^(Rn(k)/20)*sqrt(2)*std_r;
   for j=2:NSamples
      if Z(j) > R(k) & Z(j-1) <= R(k)
         Mt = Mt + 1;
      end
   end
   LCR(k) = Mt / T;
end

return;
