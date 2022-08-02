% Used in FM7-3 to demonstrate Newt_n
function y = eqn_1(x)
y = (0.01*x + 1).*sin(x)-(x-0.01) ...
              .*(x.^2+1).^(-1)-0.0096;
