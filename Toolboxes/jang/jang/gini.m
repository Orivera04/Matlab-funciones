function out = gini(count)
%GINI	Gini index function, for use as an impurity function in CART.

count = count(:);
out = 1 - sum((count/sum(count)).^2);
