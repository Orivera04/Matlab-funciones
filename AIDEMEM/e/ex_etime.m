s= char(fix(100*rand(1,10000)));
tic;
s1 =s(end:-1:1);
toc
tic
for i=1:length(s)
  s1(i)=s(end-i+1);
end;
toc
tic
i = 1;
while i <= length(s)
  s1(i)=s(end-i+1);
  i=i+1;
end;
toc;
