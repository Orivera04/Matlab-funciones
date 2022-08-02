function y = myfun(a,b)
      disp(sprintf('My first input is "%s".' ,inputname(1)))
      disp(sprintf('My second input is "%s".',inputname(2)))
      y = a+b;
end