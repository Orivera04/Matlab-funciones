% find2.m
% extending find

x=[0 9 7 0 0 0
   5 0 0 6 0 3
   0 0 0 0 0 0
   8 0 4 2 1 0] % test data

[r,c]=find(x~=0);
rt=r' % display as r and c as rows
ct=c' % to save space
j=zeros(size(x,1),1);
j(r)=c
i=zeros(size(x,2),1);
i(c)=r