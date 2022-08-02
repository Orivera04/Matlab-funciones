A=[];
for i=1:41
for j=1:41
X(i,j)=x(i,j);
Y(i,j)=y(i,j);
Z(i,j)=z(i,j);
XYZ = [X(i,j),Y(i,j),Z(i,j)];
A = [A,Rx(XYZ,45,'degrees')];
end
end
A