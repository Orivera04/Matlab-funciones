function mxmn=fuzzy_maxmin(A,B);
% Calculates max-min product of matrices A and B
for i=1:length(A(:,1))
    for j=1:length(B(1,:));
        mn=[];
        for k=1:length(B(:,1))
            mn(k)=min(A(i,k),B(k,j));
        end
        mxmn(i,j)=max(mn);
    end
end

%disp_f('Max - Min  of A and B is',mxmn);