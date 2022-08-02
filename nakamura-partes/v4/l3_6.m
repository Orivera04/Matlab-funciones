% List3_6.  See Example 3.11. Copyright S. Nakamura, 1995
clear
A = [-0.04 0.04 0.12 ; 0.56 -1.56 0.32 ...
; -0.24 1.24 -0.28]
a=[A,eye(3)];
% First pivoting (Rows 1 and 3 are exchanged)
tempo = a(2,:);  a(2,:) = a(1,:); a(1,:)=tempo;
% Fist row is divided by its pivot:
a(1,:) = a(1,:)/a(1,1)
% The elements below a(1,1) are all eliminated.
for i=2:3;  a(i,:)=a(i,:) - a(i,1)*a(1,:);  end;a
% Eliminates all the elements above and
%                             below the second pivot.
% Second pivoting
tempo = a(3,:);  a(3,:) = a(2,:); a(2,:)=tempo;a
% Normalization of second row
a(2,:)=a(2,:)/a(2,2);a
for i=1:3; if i~=2, a(i,:)=a(i,:)-a(i,2)*a(2,:); end;
end;a
% Eliminate all the elements above the third pivot.
a(3,:)=a(3,:)/a(3,3)
for i=1:3; if i~=3, a(i,:)=a(i,:)-a(i,3)*a(3,:); end;
end;a
A_inv = a(:,4:6)
A*A_inv

