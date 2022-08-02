function [Qn, A] = find_pdf(Z, NSamples, Action)
switch Action
case 'Amplitude_pdf'
   max = 6;
   min = 0;
   N = 200;
case 'Theta_pdf'
   max = 5;
   min = -5;
   N = 200;
end
delta = (max - min) / N;
for k=1:N
   x1 = min + (k-1) * delta;
   x2 = x1 + delta;
   A(k) = (x1 + x2) / 2;
   Q(k) = 0;
   for j=1:NSamples
      if (Z(j) > x1 & Z(j) <= x2)
         Q(k) = Q(k) + 1;
      end
   end
end
Qn = (Q/NSamples)/delta;
return;
