function y = ABM4(y, fvec, h)

y = y + h/24*(9*fvec(:,4) + 19*fvec(:,3) - 5*fvec(:,2) + fvec(:,1));
return