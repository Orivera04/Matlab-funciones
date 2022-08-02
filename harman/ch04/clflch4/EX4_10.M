% EX4_10.M Compare qr and eig commands to find eigenvalues
%  The script pauses after each qr iteration
A = [1 -1 0 0;3 5 0 0;0 0 1 5;0 0 -1 1]
[V,D]=eig(A)
pause
% Compute QR sequence; R*Q converges to quasi-diagonal
N=input('Number of Iterations, N= ')
for I=1:N,[Q,R]=qr(A);,I,A=R*Q,pause,end
%
% Note: this is a good script to step through to determine
%  the operation of the qr command