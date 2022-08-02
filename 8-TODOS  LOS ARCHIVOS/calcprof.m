function profit = calcprof(packstruct)
% calcprofit calculates the profit for a 
% software package
% Format: calcprof(structure w/ price & cost fields)

profit = packstruct.price - packstruct.cost;
end
