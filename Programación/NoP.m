function NoP % Number of Plane

clc

q=1;
qq=0;

cc=0;
dd=1;

while q==1,

fprintf('\n');

a=input('to insert the number with range 0-9: ');

c(1,1)=0;
d(1,1)=1;

for b=1:a,
    c(b,1)=c(b,1)+b;
    d(b,1)=d(b,1)*b;
    c(b+1,1)=c(b,1);
    d(b+1,1)=d(b,1);
end

fprintf('\n');
fprintf('sum element:');
disp(c(a+1,1))
fprintf('per element:');
disp(d(a+1,1))

% length sum vector - sum element = a --> a + 1 = length sum vector
% length per vector - per element = a --> a + 1 = length per vector

% length sum vector = length per vector

PP=d-c;

fprintf('difference:');
disp(PP(a+1,1))

% delta vector --> distance +*

% 1  2  3  4   5   6    7     8      9      10

% 0  0  0  0   0   0    0     0      0       0
% 0 -1 -1 -1  -1  -1   -1    -1     -1      -1
%   -1  0  0   0   0    0     0      0       0
%       0 14  14  14   14    14     14      14
%         14 105 105  105   105    105     105
%            105 699  699   699    699     699
%                699 5012  5012   5012    5012
%                    5012 40284  40284   40284
%                         40284 362835  362835
%                               362835 3628745 
%                                      3628745

%  1° element of delta vector -->       0 with each "a" value
%  2° element of delta vector -->      -1 with each "a" value but      0 with a=1 in the last value (external)
%  3° element of delta vector -->       0 with each "a" value but     -1 with a=2 in the last value (external)
%  4° element of delta vector -->      14 with each "a" value but      0 with a=3 in the last value (external)
%  5° element of delta vector -->     105 with each "a" value but     14 with a=4 in the last value (external)
%  6° element of delta vector -->     699 with each "a" value but    105 with a=5 in the last value (external)
%  7° element of delta vector -->    5012 with each "a" value but    699 with a=6 in the last value (external)
%  8° element of delta vector -->   40284 with each "a" value but   5012 with a=7 in the last value (external)
%  9° element of delta vector -->  362835 with each "a" value but  40284 with a=8 in the last value (external)
% 10° element of delta vector --> 3628745 with each "a" value but 362835 with a=9 in the last value (external)

% external diagonal line    --> 0 -1 0 14 105 699 5012 40284 362835 3628745 --> 10 values and 10 values of "a"
% internal diagonal line  1 --> 0 -1 0 14 105 699 5012 40284 362835 3628745 --> 10 values and 10 values of "a"
% internal diagonal line  2 --> 0 -1 0 14 105 699 5012 40284 362835         -->  9 values and 10 values of "a"
% internal diagonal line  3 --> 0 -1 0 14 105 699 5012 40284                -->  8 values and 10 values of "a"
% internal diagonal line  4 --> 0 -1 0 14 105 699 5012                      -->  7 values and 10 values of "a"
% internal diagonal line  5 --> 0 -1 0 14 105 699                           -->  6 values and 10 values of "a"
% internal diagonal line  6 --> 0 -1 0 14 105                               -->  5 values and 10 values of "a"
% internal diagonal line  7 --> 0 -1 0 14                                   -->  4 values and 10 values of "a"
% internal diagonal line  8 --> 0 -1 0                                      -->  3 values and 10 values of "a"
% internal diagonal line  9 --> 0 -1                                        -->  2 values and 10 values of "a"
% internal diagonal line 10 --> 0                                           -->  1 value  and 10 values of "a"
% external plane of zero    --> 1 + 2 + 3 + 4 + 5 + 6 + 7 + 8 + 9 = 45 zeros

m=[0 -1 0 14 105 699 5012 40284 362835 3628745;
   0 -1 0 14 105 699 5012 40284 362835 3628745;
   0 -1 0 14 105 699 5012 40284 362835       0;  
   0 -1 0 14 105 699 5012 40284      0       0;
   0 -1 0 14 105 699 5012     0      0       0;
   0 -1 0 14 105 699    0     0      0       0;
   0 -1 0 14 105   0    0     0      0       0;
   0 -1 0 14   0   0    0     0      0       0;
   0 -1 0  0   0   0    0     0      0       0;
   0 -1 0  0   0   0    0     0      0       0;
   0  0 0  0   0   0    0     0      0       0];

% matrix 11x10 --> 110 elements --> 10 + 10 + 45 + 45

ma=[0 -1 0 14 105 699 5012 40284 362835 3628745;
    0 -1 0 14 105 699 5012 40284 362835 3628745;
    0 -1 0 14 105 699 5012 40284 362835       0;  
    0 -1 0 14 105 699 5012 40284      0       0;
    0 -1 0 14 105 699 5012     0      0       0;
    0 -1 0 14 105 699    0     0      0       0;
    0 -1 0 14 105   0    0     0      0       0;
    0 -1 0 14   0   0    0     0      0       0;
    0 -1 0  0   0   0    0     0      0       0;
    0 -1 0  0   0   0    0     0      0       0];

% matrix 10x10 --> 100 elements --> 10 + 10 + 45 + 35

b=zeros(1,10);

% vector 1x10 --> 10 elements --> 0 + 0 + 0 + 10

qq=qq+1;

fprintf('number position:');
disp(qq);

cc=cc+c(a+1,1);
dd=dd*d(a+1,1);

fprintf('total sum:');
disp(cc);
fprintf('total per:');
disp(dd);

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

c(1,1)=0;
d(1,1)=1;

for b=1:N,
    c(b,1)=c(b,1)+b;
    d(b,1)=d(b,1)*b;
    c(b+1,1)=c(b,1);
    d(b+1,1)=d(b,1);
end

fprintf('\n');
fprintf('sum element:');
disp(c(N+1,1))

fprintf('\n');
fprintf('number of line:'); % sum element / input number
if N>0,
    disp((c(N+1,1)/N))
else fprintf('   NaN\n');
    fprintf('\n');
end

fprintf('\n');
fprintf('per element:'); % 3D
disp(d(N+1,1))

fprintf('\n');
fprintf('number of plane:'); % per element / ( sum element / input number )
if N>0,
    disp(d(N+1,1)/(c(N+1,1)/N))
else fprintf('   NaN\n');
end 

% number of line * number of plane = per element

% FORMULA --> ( input number + 1 ) / 2 = number of line --> per element = number of plane * ( input number + 1 ) / 2
