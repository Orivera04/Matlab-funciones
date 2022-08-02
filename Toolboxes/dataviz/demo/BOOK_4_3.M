%  book_4_3.m
%  calls coplot

load rubber

data = [Hardness(:) TensileStrength(:) AbrasionLoss(:)];
labels = {'Hardness' 'Tensile Strength' 'Abrasion Loss'};

%  interval parameters
np = 6;  %  number of intervals
overlap = 3/4;
intervalParams = [np overlap];

%  loess curve fit parameters
alpha = 3/4;
lambda = 1;
robustFlag = 0;
fitParams = [alpha lambda robustFlag];

coplot(data,labels,intervalParams,fitParams)
