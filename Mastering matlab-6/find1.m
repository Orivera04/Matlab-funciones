% find1.m
% extending find

x=[4 9 1 0 3 4 0
   8 2 7 1 0 0 0
   3 7 1 9 0 2 5
   9 5 2 8 2 1 0
   8 5 2 7 5 8 3]; % test data

xr=size(x,1);  % row dimension of x
j=zeros(xr,1); % preallocate result

% find last element equal to one in each row
for i=1:xr
   tmp=find(x(i,:)==1);
   if ~isempty(tmp) % beware of empties
      j(i)=tmp;
   end
end