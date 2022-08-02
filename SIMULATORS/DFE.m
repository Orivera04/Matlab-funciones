%This function simulates a DFE with fftap_num of feed foward taps and fbtap_num of feedback taps
%inputs: rn - received bit sequence
%        Pi        - input power
%        fftap_num - number of feedforward taps
%        fbtap_num - number of feedback taps
%        An        - desired bit sequence
%        type      - a control signal deciding whether the desired signal is available to the 
%                    equalizer or not.
%outputs: x        - the decoded signal.

function x = DFE(rn, Pi, fftap_num, fbtap_num, An, type)
global A cn tn;

y_ff = 0;
y_fb = 0;

if(fftap_num > 0)
for k=1:fftap_num
   y_ff = y_ff + rn(k)*cn(k);
end
end

if(fbtap_num > 0)
for k=1:fbtap_num
   y_fb = y_fb + tn(k)*cn(k+fftap_num); %(tn = xn)
end
end

yn = y_ff - y_fb;
if real(yn) >= 0
   xn = A;
else
   xn = -A;
end

switch type
case 1
   err = xn - yn;
case 2
   err = An - yn;
end

alpha1 = 1/(15*Pi)/20;
alpha2 = 0.1/20;
 

%only have to calculate tap coefficients if doing 3-taps
if (fftap_num > 0)
for k=1:fftap_num
   cn(k) = cn(k) + alpha1 * err * rn(k);
end
end

if (fbtap_num > 0)
for k=1:fbtap_num
   cn(k+fftap_num) = cn(k+fftap_num) - alpha2 * err * tn(k);
end
end

%only needed if there is 2 feedback taps 
if (fbtap_num > 1)
   for k=fbtap_num:2
   tn(k) = tn(k-1);
end
end

tn(1) = xn;
x = xn;
return;
