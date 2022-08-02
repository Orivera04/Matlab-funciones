% Function file phi.m                         
function y = phi(x)                           
a = 0.4361836;                                
b = -0.1201676;                               
c = 0.937298;                                 
r = exp(-0.5 * x * x) / sqrt(2 * pi);         
t = 1 / (1 + 0.3326 * x);                     
y = 0.5 - r * (a * t + b * t * t + c * t ^ 3);