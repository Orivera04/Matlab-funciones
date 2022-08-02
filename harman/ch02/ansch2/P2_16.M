% P2_16.M Show round off error
N=input('Input number of additions ')
xsum = 0;
for i=1:N
 xsum = xsum + 1e-6;
end
% Display value and difference
xsum
xdiff=xsum - N*1e-6
	