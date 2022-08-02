function rulenumber=rulenumberencoder(rulenumberbinary,rulecolors)
% rulenumberbinary must be an array!
[rulenumberbinaryrows,rulenumberbinarycols]=size(rulenumberbinary);
rulenumber=0;
for checking=0:rulenumberbinarycols-1;
    rulenumber=(rulenumberbinary(end-checking) * rulecolors^checking) + rulenumber;
end;