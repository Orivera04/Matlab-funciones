function mxmn=fuzzy_minmax(A,B)
% Calculates min-max product of matrices A and B
for i=1:length(A(:,1));
    for j=1:length(B(1,:));
        mn=[];
        for k=1:length(B(:,1));
            mn(k)=max(A(i,k),B(k,j));
        end
        mxmn(i,j)=min(mn);
    end
end

%disp_f('Min - Max  of A and B is',mxmn);