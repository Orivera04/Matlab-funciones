function M=m_exit(ptp0)
dM=0.1;M=0;
for it=1:10
f = ptp0 - 1/(1 + 0.2*M^2)^3.5;
if abs(f)<0.00001 break;end
fb = ptp0 - 1/((1 + 0.2*(M+dM)^2))^(3.5);
fd=(fb-f)/dM;
M=M-f/fd;
if abs(f)<0.00001 break,end
end
