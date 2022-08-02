function y = AB4(y, fvec, h)

y = y + h/24*(55*fvec(:,4) - 59*fvec(:,3) + 37*fvec(:,2) - 9*fvec(:,1));
return