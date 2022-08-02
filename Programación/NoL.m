function NoL % Number of Line

clc

q=1;
qq=0;

while q==1,

    fprintf('\n');
    a=input('to insert the number with range 0-9: ');
    
    c(qq+1,1)=0;
    
    for b=1:a,
        c(qq+1,b)=c(qq+1,b)+b;
        c(qq+1,b+1)=c(qq+1,b);
    end
    
    fprintf('\n');
    fprintf('sum element:');
    disp(c(qq+q,a+1))
    qq=qq+1;
    fprintf('number position:');
    disp(qq);
    fprintf('sequence of sum:');
    disp(c(qq,:));
    aa(1,qq)=a;
    q=input('other number? 1=yes 0=no ... ');
    fprintf('\n');
    fprintf('\n');
    
end

for cu=1:qq,
    n(1,cu)=aa(1,cu)*10^(qq-cu);
end

N=sum(n);

fprintf('\n');
fprintf('input number:');
disp(N)
fprintf('\n');
fprintf('sum matrix\n');
fprintf('\n');
disp(c)

% number of row = number of instant 
% number of rows = number of numbers in the value
% number of column = number of space
% number of columns = max number in the value

% number of row & number of column = number of instant & number of space --> the element
% number of rows & number of columns = number of numbers in the value & max number in the value --> the matrix dimensions

% N times the element = the matrix dimensions

s=size(c);
k=0;
su=0;

for x=1:s(1,1),
    for y=1:s(1,2),
        if c(x,y)==0,
            k=k+1;
        end
        su=su+c(x,y);
    end
end

fprintf('\n');
fprintf('number of zeros:   ');
disp(k)
fprintf('number of not zero:');
disp(s(1,1)*s(1,2)-k)
fprintf('number of row-instants: ');
disp(s(1,1))
fprintf('number of column-spaces:');
disp(s(1,2))
fprintf('number of elements:');
disp(s(1,1)*s(1,2))
fprintf('number of sum matrix element:');
disp(su)

c(1,1)=0;

for b=1:N,
    c(b,1)=c(b,1)+b;
    c(b+1,1)=c(b,1);
end

fprintf('\n');
fprintf('sum element:');
disp(c(N+1,1))

fprintf('\n');
fprintf('number of line:'); % sum element / input number
if N>0,
    disp(c(N+1,1)/N)
else fprintf('   NaN');
end

% input number = 0
% number of line = NaN

% input number = 1
% number of line = 1

% input number = 2
% number of line = 1.5

% input number = 3
% number of line = 2

% input number = 4
% number of line = 2.5

% input number = 5
% number of line = 3

% input number = 6
% number of line = 3.5

% input number = 7
% number of line = 4

% input number = 8
% number of line = 4.5

% input number = 9
% number of line = 5

% input number = 10
% number of line = 5.5

% input number = 11
% number of line = 6

% FORMULA --> input number - number of line = number of line - 1

% -NaN = NaN - 1 --> NaN = 1/2

% FORMULA --> input number = 2 number of line - 1

% number of line with decimal 0.5 --> even input number
% number of line with decimal zero --> odd input number

% even input number --> even last number: 0 2 4 6 8
% odd input number --> odd last value: 1 3 5 7 9

% input number --> 10 numbers: 0 1 2 3 4 5 6 7 8 9

% even input number --> 5 numbers
% odd input number --> 5 numbers
