function mult_npol = producto(n)
%Multiplicaci�n de n monomios: (x-a1)^m1* (x-a1)^m2... (x-an)^mn
%A=[a1,a2,...,an].  M=[m1,m2,...,mn]
syms x;
A=input('D� los valores del vector A: ');
M=input('D� los valores del vector M: ');
p=[1];
for i=1:n
    q=expand((x-A(i))^M(i));
    q1=sym2poly(q);
    p=conv(p,q1);
end
mult_npol=p;