% updown4.m
% up-down algorithm

%Nums = 25:50;          % numbers to test
N=Nums;                % duplicate numbers
Counts=zeros(size(N)); % preallocate array
idx=find(N>1);         % indices of not done values
while ~isempty(idx)
   odd=logical(rem(N(idx),2)); % True where odd
   oidx=idx(odd);      % indices where odd
   eidx=idx(~odd);     % indices where even
   
   N(eidx)=N(eidx)/2;           % operate on all evens
   Counts(eidx)=Counts(eidx)+1; % increment even counts
   
	N(oidx)=(3*N(oidx)+1)/2;     % operate on all odds
   Counts(oidx)=Counts(oidx)+2; % increment odd counts
   
   idx=find(N>1);      % eliminate converged values from
                       % further consideration
end
%results=[Nums' Counts']