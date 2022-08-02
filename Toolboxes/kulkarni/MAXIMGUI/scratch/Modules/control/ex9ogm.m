function P = ex9ogm(x,a)
%P = ex9ogm(x,a)
% returns the trans. prob. matrix P(a) if a = 1,2,3,....
% returns the cost matrix if a = -1 for the group maintenance example.
% N = number of machines
% p = probability of surviving for one more day.
% cr = cost of a new item;
% cv = fixed cost of replacement;
% r = revenue from a working machine in a day
   
N=x(1); p=x(2); cr=x(3); cv=x(4); r=x(5);
if a == -1
P=zeros(N+1,N+1);
P=-[0:N]'*[1 zeros(1,N)]*r + ones(N+1,1)*[0:N]*cr + ones(N+1,1)*[0 ones(1,N)]*cv;

elseif a == 1
   P=zeros(N+1,N+1);
   P(:,1)=(1-p).^[0:N]';
   for k=1:N
      for j=1:k
         P(k+1,j+1) = p*P(k,j)+(1-p)*P(k,j+1);
      end
   end
   
elseif (a - fix(a) == 0)&(2 <= a)&(a <= N+1) 
P=zeros(N+1,N+1) + diag(ones(1,N-a+2),a-1);
P(:,N+1) = [zeros(N-a+1,1) ;ones(a,1)];
else 
msgbox('undefined action');return;
end;
