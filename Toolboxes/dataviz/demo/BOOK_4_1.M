%  book_4_1.m
%  calls scattermatrix

load rubber

data = [Hardness TensileStrength AbrasionLoss];
label = {'Hardness' 'Tensile Strength' 'Abrasion Loss'};

scattermatrix(data,label)
