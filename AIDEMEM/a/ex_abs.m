a = reshape(0:8,3,3)+i*reshape(8:-1:0,3,3)
b =  abs(a)               % module
c =  angle(a)*180/pi      % argument en degré
d =  -3:3, e =  abs(d)
figure('name','abs');
subplot(2, 1, 1); z = cplxgrid(20); cplxmap(z,abs(z));
subplot(2, 1, 2); z = cplxgrid(20); cplxmap(z,angle(z));
