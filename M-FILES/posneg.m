function out = posneg(in)

% Test for all positive (1), or all negative (-1) elements.

if all(in>0)
  out = 1;
elseif all(in<0)
  out = -1;
else 
  out = 0;
end
