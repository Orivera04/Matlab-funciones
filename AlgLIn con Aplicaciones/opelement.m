% An M-file to demonstate how elementary matrix row operations
% as used in Gauss-Jordan elimination may be interpreted graphically.

% Benjamin N. Levy, 1997

disp('Graphical interpretation of elementary matrix row operations')
disp('as used in Gauss-Jordan elimination.')
disp(' ')
disp('Enter the coefficients of two linear equations,')
disp('     ax + by = c  and  dx + ey = f')
disp('(but with neither equation corresponding to a vertical or horizontal line,')
disp(' so the coefficients  a, b, d, and e  are all nonzero).')

a = input('In ax + by = c,  a = ');
b = input('                 b = ');
c = input('                 c = ');
d = input('In dx + ey = f,  d = ');
e = input('                 e = ');
f = input('                 f = ');

disp(' ')
disp('Press ENTER to continue now and after each graph is displayed.')
disp(' ')
pause
M = [a b c; d e f];
disp(' ')
disp('original matrix:')
disp(M)

x = -20:20:20;
y1 = M(1,3)/M(1,2) - (M(1,1)/M(1,2))*x;
y2 = M(2,3)/M(2,2) - (M(2,1)/M(2,2))*x;
plot(x,y1,'r-',x,y2,'b-'); title('graphs of original equations')
pause

disp('matrix with leading 1 in row 1:')
M1 = M;
M1(1,:) = M1(1,:)/M1(1,1);
disp(M1)

y1 = M1(1,3)/M1(1,2) - (1/M1(1,2))*x;
y2 = M1(2,3)/M1(2,2) - (M1(2,1)/M1(2,2))*x;
plot(x,y1,'r-',x,y2,'b-'); title('after leading 1 in row 1')
pause

disp('matrix with 0 below leading 1 in column 1:')
M2 = M1;
M2(2,:) = M2(2,:)-M2(2,1)*M2(1,:);
disp(M2)

if M2(2,2) ~= 0

y1 = M2(1,3)/M2(1,2) - (1/M2(1,2))*x;
y2 = M2(2,3)/M2(2,2) + 0*x;
plot(x,y1,'r-',x,y2,'b-'); title('after 0 below leading 1 in column 1')
pause

disp('matrix with leading 1 in row 2:')
M3 = M2;
M3(2,:) = M3(2,:)/M3(2,2);
disp(M3)

y1 = M3(1,3)/M3(1,2) - (1/M3(1,2))*x;
y2 = M3(2,3) + 0*x;
plot(x,y1,'r-',x,y2,'b-'); title('after leading 1 in row 2')
pause

disp('matrix with 0 above leading 1 in column 2:')
M4 = M3;
M4(1,:) = M4(1,:)-M4(1,2)*M4(2,:);
disp(M4)
disp('The solution is:')
X = M4(1,3)
Y = M4(2,3)

plot(M4(1,3) + 0*x,x,'r-',x,M4(2,3) + 0*x,'b-'); title('after 0 above leading 1 in column 2')

elseif M2(2,3) == 0
disp(' ')
disp('     Infinitely many solutions')

else
disp(' ')
disp('     Inconsistent system')

end
