function f_eps=fuzzy_epsilon(A,B)
% Calculates epsilon product of matrices A and B
for i=1:length(A(:,1))
    for j=1:length(B(1,:))
        for k=1:length(B(:,1))
            if A(i,k)>=B(k,j)
                eps_k(k)=0;
            else
                eps_k(k)=B(k,j);
            end
            f_eps(i,j)=max(eps_k);
        end
    end
end

%disp_f('Epsilon Composition of A and B is',f_eps);