%This function simulates a DFE with fftap_num of feed foward taps and fbtap_num of feedback taps
%inputs: rn - received bit sequence
%        Pi        - input power
%        tap_num   - number of taps
%        An        - desired bit sequence
%        type      - a control signal deciding whether the desired signal is available to the 
%                    equalizer or not.
%outputs: x        - the decoded signal.


function [x] = linear_eq (rn, Pi, tap_num, An, type);
global A bn;

yn = 0;
for k=1:tap_num
   yn = yn + rn(k)*bn(k);
end

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
alpha = 1/(15*Pi)/20;

for k=1:tap_num
   bn(k) = bn(k) + alpha * err * rn(k);
end

x = xn;
return;
