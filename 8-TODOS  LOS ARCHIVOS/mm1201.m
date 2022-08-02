% nested function example

ratpoly1 = nestexample([1 2],[1 2 3]) % (x + 2)/(x^2 + 2x + 3)
ratpoly2 = nestexample([2 1],[3 2 1]) % (2x +1)/(3x^2 + 2x +1)

x=linspace(-10,10); % independent variable data
y1=ratpoly1(x); % evaluate first rational polynomial
y2=ratpoly2(x); % evaluate second rational polynomial

plot(x,y1,x,y2) % plot created data
xlabel('X')
ylabel('Y')
title('Figure 12.1: Rational Polynomial Evaluation')
