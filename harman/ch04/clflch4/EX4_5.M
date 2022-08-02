% EX4_5.M  Verify Example 4.5 and demonstrate Equation4.20
%  INPUT:  Battery Voltage values [V1 V2]
%  OUTPUT: Current in the loops 
V=input('Battery voltage in loop 1 and 2 [V1 V2]= ')
va=[1 1]';     % Eigenvectors
vb=[1 -1]';
c1=(V(1)+V(2))/2;  % Compute coefficients
c2=(V(1)-V(2))/2;
fprintf(' The currents are as follows')
i=(1/3)*c1*va + c2*vb
