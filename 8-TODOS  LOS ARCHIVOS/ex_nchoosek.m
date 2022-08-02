for i = 0:5
  for j = 0:i
    fprintf('%4d',nchoosek(i, j));
  end;
  fprintf('\n');
end;
nchoosek(1:4,3)

