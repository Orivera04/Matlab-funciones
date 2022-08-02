% Linear equations system Ax=r
% Gauss elimination with partial pivoting
% written by : Meysam Rezaei Barmi
% MSc Student of Mechanical engineering of University of Tehran
clc
clear all

%-------------------------------------------------------------------
% Matrix Definition
A=[1 2 3 4 5 6;2 -2 4 9 6 5;5 6 9 -4 3 0;-1 0 5 -9 11 2;1 -4 7 -9 3 1;-9 6 0 4 -8 1];
r=[1;2;3;-2;6;5];
[row,col]=size(A);
n=row;
%-------------------------------------------------------------------
B=A;
b=r;
C=B;
c=b;
for i=1:n
    [maxi,row]=max(abs(C(:,i)));
    if C(row,i)<0
        maxi=-maxi;
    end
    B(i,:)=C(row,:);
    B(row,:)=C(i,:);
    b(i)=c(row);
    b(row)=c(i);

    B(i,:)=B(i,:)/maxi;
    b(i)=b(i)/maxi;
    C=B;
    for j=i+1:n
        B(j,:)=B(j,:)-C(j,i)*B(i,:);
        b(j)=b(j)-C(j,i)*b(i);
    end
    C=B;
    C(i,:)=0;
    C(:,i)=0;
    c=b;    
end
%-------------------------------------------------------------------
x(n)=b(n);
for i=n-1:-1:1
    sum=0;
    for j=i+1:n
        sum=sum+B(i,j)*x(j);
    end
    x(i)=(1/B(i,i))*(b(i)-sum);
end

%-------------------------------------------------------------------
% Input
% Ax=r
disp(' Input    Ax=r')
disp(' Input Matrix A =')
disp(A)
disp(' r =')
disp(r)

% Output
% Bx=b
disp(' Output   Bx=b')
disp(' Upper triangular Matrix B =')
disp(B)
disp(' b=')
disp(b)
disp(' Solution of linear equations system :')
disp(x')

% Solve linear equation system with Matlab Function for checking result
disp(' Solution with Matlab Functions :')
s=inv(A)*r;
disp(s)


