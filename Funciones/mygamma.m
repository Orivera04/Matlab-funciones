
function y = mygamma(t)

% Valu(s) y of the Euler's gamma function evaluated
% at t (t > -1).

td= t - fix(t);
if td == 0
   n = ceil(t/2);
else
   n = ceil(abs(t)) + 10;
end
y = Gquad2('pow',n,'L',t-1);


function z = pow(x, e)

% Power function z = x^e

z = x.^e;

