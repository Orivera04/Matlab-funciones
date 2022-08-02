% updown5.m
% up-down algorithm

%Nums = 25:50;          % numbers to test
Nl=length(Nums);       % number of values
N=Nums;                % duplicate numbers
Counts=zeros(size(N)); % preallocate array
Ndone=Counts;          % preallocate array
Cdone=Counts;          % preallocate array
n=0;                   % pointer

while n<Nl
   odd=logical(rem(N,2)); % True where odd
   even=~odd;             % True where even

   N(even)=N(even)/2;           % operate on all evens
   Counts(even)=Counts(even)+1; % increment even counts
   
   N(odd)=(3*N(odd)+1)/2;       % operate on all odds
   Counts(odd)=Counts(odd)+2;   % increment odd counts
   
   done=(N==1);   % True for converged values
   Nd=sum(done);  % Number of converged values

   if Nd>0  % Purge N and Counts of converged values
      idx=n+(1:Nd);            % where to store converged data
      Ndone(idx)=Nums(done);   % store converged values
      Cdone(idx)=Counts(done); % store converged counts
      Nums(done)=[];           % throw out converged values
      N(done)=[];              % and converged iterations
      Counts(done)=[];         % and converged counts
      n=idx(end);              % last element in Ndone and Cdone
   end
end
[Nums,idx]=sort(Ndone); % sort results
Counts=Cdone(idx);      % shuffle Counts to match Nums
%results=[Nums' Counts']