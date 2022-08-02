function outvar = recurfn(num)
% Format: recurfn(number)

if num < 0
   outvar = 4;
else
   outvar = 3 + recurfn(num-1);
end
end