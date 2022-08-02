function idx=mmakeidx(lo,hi)
%MMAKEIDX Make Index Vector From Limits.
% MMAKEIDX(Lo,Hi) creates an index vector from the vectors Lo and Hi.
%
% Lo and Hi are vectors containing low and high indices of segments
% to be addressed.
% MMAKEIDX returns [Lo(1):Hi(1) Lo(2):Hi(2) ... Lo(end):Hi(end)].

if nargin~=2
   error('Two Input Arguments Required.')
end
if any(fix(lo)~=lo)|any(fix(hi)~=hi)
   error('Lo and Hi Must Contain Integers.')
end
if length(lo)~=length(hi)
   error('Lo and Hi Must Have the Same Length.')
end
if any((hi-lo)<0)
   error('Lo(i) Must be Less Than Hi(i).')
end

n=length(lo);

run=hi-lo+1;           % length of each run
last=cumsum(run);      % last index of each run

idx=ones(1,last(end)); % preallocate result
idx(1)=lo(1);          % poke in first value
idx(1+last(1:end-1))=lo(2:n)-hi(1:n-1); % poke in jumps
idx=cumsum(idx);