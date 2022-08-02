% Used by guidm_18
function M=mach(ar,M)
dM=0.01;Mb=M+dM;
fb = ar*(Mb) - ( 0.833333*(1 + 0.2*(Mb)^2))^3;
for it=1:20
   f = ar*M - ( 0.833333*(1 + 0.2*M^2))^3;
    Ma=M;
   if abs(f)<0.000001 break;end
   M=M-f*(Mb-M)/(fb-f);
   Mb=Ma;fb=f;
end

