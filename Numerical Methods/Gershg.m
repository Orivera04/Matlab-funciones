
function C = Gershg(A)

% Gershgorin's circles C of the matrix A.  

d = diag(A);
cx = real(d);
cy = imag(d);
B = A - diag(d);
[m, n] = size(A);
r = sum(abs(B'));
C = [cx cy r(:)];
t = 0:pi/100:2*pi;
c = cos(t);
s = sin(t);
[v,d] = eig(A);
d = diag(d);
u1 = real(d);
v1 = imag(d);
hold on
grid on
axis equal
xlabel('Re')
ylabel('Im')
h1_line = plot(u1,v1,'or');
set(h1_line,'LineWidth',1.5)
for i=1:n
x = zeros(1,length(t));
y = zeros(1,length(t));
   x = cx(i) + r(i)*c;
   y = cy(i) + r(i)*s;
   h2_line = plot(x,y);
   set(h2_line,'LineWidth',1.2)
end
hold off
title('Gershgorin circles and the eigenvalues of a matrix')


