function outvec = myveccumsum(vec)
% myveccumsum simulates cumsum for a vector
% Format: myveccumsum(vector)
 
outvec = [];
runsum = 0;
for i = 1:length(vec)
    runsum = runsum + vec(i);
    outvec = [outvec runsum];
end
end
