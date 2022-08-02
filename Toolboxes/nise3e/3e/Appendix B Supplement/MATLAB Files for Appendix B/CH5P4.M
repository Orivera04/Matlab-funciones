% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
%
% Control Systems Engineering Toolbox Version 3.0 
% Copyright © 2000 by John Wiley & Sons, Inc.
%
% (ch5p4) Example 5.10: We can use MATLAB to perform similarity transformations 
% to obtain other forms. Let us look at Example 5.10 in the text.

'(ch5p4) Example 5.10'              % Display label.
Pinv=[2 0 0;3 2 0;1 4 5];           % Define P inverse.
P=inv(Pinv)                         % Calculate P.
'Original'                          % Display label.
Ax=[0 1 0;0 0 1;-2 -5 -7]           % Define original A.
Bx=[0 0 1]'                         % Define original B.
Cx=[1 0 0]                          % Define original C.
'Transformed'                       % Display label.
Az=Pinv*Ax*P                        % Calculate new A.
Bz=Pinv*Bx                          % Calculate new B.
Cz=Cx*P                             % Calculate new C.
