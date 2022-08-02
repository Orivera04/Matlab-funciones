function Ranks=Combin2Rank(n,k,Combins)
% calculates the rank (sequential ordinal) of nCk combinations
% n,k: scalars; Combins: m x k; Ranks: m x 1.
% vectorized for n<100. Generates the auxiliary CombTable.mat file
%
% ref: A Numbering System for Combinations, Gary D. Knott, Communications of the ACM, Jan. 1974, v.17, n.1
%
% Example:
%
% Combs=nchoosek(1:5,3)
% Combs =
%      1     2     3
%      1     2     4
%      1     2     5
%      1     3     4
%      1     3     5
%      1     4     5
%      2     3     4
%      2     3     5
%      2     4     5
%      3     4     5
% Combin2Rank(5,3,Combs)
% ans =
%      1
%      2
%      3
%      4
%      5
%      6
%      7
%      8
%      9
%     10

q=n-1-fliplr(Combins-1); s=k; % rename variables to match the paper, where the combinations include 0

if n<100    % use vectorized version

    persistent nCs  % store locally Combinations table
    if ~length(nCs) % load Combinations table
        if ~exist('CombTable.mat')  % if not exists, generate
            nCs=MakeCombTable;
        else
            load CombTable
            disp('Combin2Rank: CombTable loaded')
        end
    end

    I=sub2ind(size(nCs),q+1,repmat((1:s)+1,size(q,1),1)); % indexes to combinations
    nu=sum(nCs(I),2);
    Ranks=nCs(n+1,s+1)-nu;

else    % calculate iteratively

    Ranks=zeros(size(q,1),1);
    for m=1:size(q,1)
        nu=nu_(q(m,:),s);
        Ranks(m)=nCk_(n,s)-nu;
    end

end

end


function nu=nu_(p,s)
nu=0;
for i=1:s
    nu=nu+nCk_(p(i),i);
end
end

function c=nCk_(n,k) % picked from nchoosek :-)
nums = (n-k+1):n;
dens = 1:k;
nums = nums./dens;
c = round(prod(nums));
end

function nCs=MakeCombTable
disp 'Combin2Rank: generating Combinations table'
nCs=zeros(100,100);
for n=0:99
    for s=0:99
        nCs(n+1,s+1)=nCk_(n,s);
    end
end
disp ('Combin2Rank: end generation')
save CombTable nCs
end

