function  [A,B]=zerodiag_eq(n);
% function  [A,B]=zerodiag_eq(n);
% generates input matrices A, size "n x n" and B 
% where A with zeros in the main diagonal
% A=[0    0.7    0.7
%    0.7    0    0.7
%    0.7    0.7    0]
% B= [0.7
%     0.7
%     0.7]
% input for solve_fls

for i=1:n

   % change the value of B(i) here:
    B(i)=0.7;


    for j=1:n
        if i==j
            A(i,j)=0;
        else
            A(i,j)=B(i);
        end
    end
end
B=B';