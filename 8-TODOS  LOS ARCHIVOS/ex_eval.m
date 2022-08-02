x = fix(rand(1,3)*10)
for i = x
  eval(['t' num2str(i) ' = i']);
end;