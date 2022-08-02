function vaultlsq                          %last updated 1/21/94
%VAULTLSQ  A routine to show linearity in three 'eras' for
%          the men's Olympic pole vault event. A single picture is produced.
%
%          This routine requires file pvault.mat which contains the data
%          for the pole vault event. The data is divided into subsets:
%
%                  Yr   Ht
%          Vectors x1 & y1 are the data for 1896 - 1924
%          Vectors x2 & y2 are the data for 1928 - 1960
%          Vectors x3 & y3 are the data for 1964 - 1988
%          Vectors x4 & y4 are the data for 1964 - 1992
%          Vectors x  & y  are the data for 1896 - 1988
%          Vectors xn & yn are the data for 1896 - 1992
%
%          Use in the form --> vaultlsq  <--
%
% By; David R. Hill, Math Dept
%     Temple University, Philadelphia, Pa.  19122

load pvault
A1=[x1 ones(size(x1))];
A2=[x2 ones(size(x2))];
A3=[x3 ones(size(x3))];

c1=inv(A1'*A1)*A1'*y1;
c2=inv(A2'*A2)*A2'*y2;
c3=inv(A3'*A3)*A3'*y3;
figure
axis([1880 2000 120 250])
plot(x1,y1,'*g'),title('Men''s Olympic Pole Vault Data')
hold on
plot([x1(1) x1(7)],[c1(1)*x1(1)+c1(2),c1(1)*x1(7)+c1(2)],'-g')

plot(x2,y2,'*w')
plot([x2(1) x2(7)],[c2(1)*x2(1)+c2(2),c2(1)*x2(7)+c2(2)],'-w')

plot(x3,y3,'*b')
plot([x3(1) x3(7)],[c3(1)*x3(1)+c3(2),c3(1)*x3(7)+c3(2)],'-b')
xlabel('Press ENTER to Continue.')
hold off
%pause
clc
disp('Routine vaultlsq is over.')

