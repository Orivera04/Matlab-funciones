function  [A,B]=zerodiag2(n);
% function  [A,B]=zerodiag2(n);
% generates input matrices A, size "n x n" and B 
% where A with zeros in two diagonals
%
% A  =
%         0         0    1.0000
%    0.6667         0         0
%    0.3333    0.3333         0
% B =
%    1.0000
%    0.6667
%    0.3333
% input for solve_fls

for i=1:n

    B(i)=1-((i-1)/(n));

    for j=1:n
        if i==j
            A(i,j)=0;
        else
            A(i,j)=B(i);
        end
    end
    
    for j=2:n
        if i==(j-1)
            A(i,j)=0;
        end
    end

end
B=B';