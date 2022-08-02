function [s,r] = goldfract(n)
%GOLDFRACT   Golden ratio continued fraction.
%  [s,r] = GOLDFRACT(n) returns two strings, both representing
%  the Golden Ratio continued fraction truncated at n terms.
%  s is the continued fraction of repeated divisions and r is the same
%  quantity flattened to the ratio of two integers.
%  Applying the eval function to either produces a floating point value.
%  ex:
%     [s,r] = goldfract(5)
%     s =
%     1 + 1/(1 + 1/(1 + 1/(1 + 1/(1))))
%     r =
%     8/5
%     eval(s)
%     ans =
%         1.6000

s = '1';
for k = 2:n
   s = ['1 + 1/(' s ')'];
end

p = 1;
q = 1;
for k = 2:n
   t = p;
   p = p + q;
   q = t;
end
r = [num2str(p) '/' num2str(q)];
