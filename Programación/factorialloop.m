for number = 1:500
  fact = 1;
  for i = 2:number
    fact = fact*i;
  end
  y(number) = fact;
end