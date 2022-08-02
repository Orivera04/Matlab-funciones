function out = entropy(count)
%ENTROPY Entropy function, for use as an impurity function in CART.

count = count(:);
prob = count/sum(count);
prob(find(prob <= 0)) = [];
out = sum(-prob.*log(prob));
