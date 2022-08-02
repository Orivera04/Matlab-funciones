function alf=fuzzy_alpha(A,B)
% Calculates alpha product of matrices A and B
for i=1:length(A(:,1))
    for j=1:length(B(1,:))
        for k=1:length(B(:,1))
            if A(i,k)<=B(k,j)
                alfa_k(k)=1;
            else
                alfa_k(k)=B(k,j);
            end
            alf(i,j)=min(alfa_k);
        end
    end
end

%disp_f('Alfa Composition of A and B is',alf);