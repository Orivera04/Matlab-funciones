function ndec=clbindec(xbin)
% CALL:  ndec=clbindec(xbin), Convert positive binary number xbin 
%  to decimal value ndec. Note: No error check if xbin is not binary
m=length(xbin);
ndec=0;
for I=1:m
 ndec=ndec+xbin(I)*2^(m-I);
end
