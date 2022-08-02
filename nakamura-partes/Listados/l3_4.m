% L3_4. See Example 3.8. Copyright S. Nakamura, 1995
clear
a = [-0.04 0.04 0.12 3; 0.56 -1.56 0.32 1; -0.24 1.24 -0.28 0]
x = [0,0,0]';  % x is initialized as a column vector
% First pivoting (Rows 1 and 2 are exchanged)
tempo = a(2,:);  a(2,:) = a(1,:); a(1,:)=tempo;a
% Elimination of elements below the first pivot.
a(2,:) = a(2,:) - a(1,:)*a(2,1)/a(1,1);
a(3,:) = a(3,:) - a(1,:)*a(3,1)/a(1,1);a
% Second pivoting (Rows 2 and 3 are exchanged)
tempo = a(3,:);  a(3,:) = a(2,:); a(2,:)=tempo;a
% Eliminating the elements below the second pivot.
a(3,:) = a(3,:) - a(2,:)*a(3,2)/a(2,2);a
x(3) = a(3,4)/a(3,3);
x(2) = (a(2,4) - a(2,3)*x(3))/a(2,2);
x(1) = (a(1,4) - a(1,2:3)*x(2:3))/a(1,1);x

