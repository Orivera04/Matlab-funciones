% This shows the timing difference between
% preallocating a vector vs. not

clear
disp('No preallocation')
tic
for i = 1:10000
    x(i) = sqrt(i);
end
toc
 
disp('Preallocation')
tic
y = zeros(1,10000);
for i = 1:10000
    y(i) = sqrt(i);
end
toc
