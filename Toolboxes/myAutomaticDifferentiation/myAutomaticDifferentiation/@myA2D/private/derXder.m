function secder = derXder(derA, derB)

for i = 1:size(derA,1)
    secder(i,:,:) = derA(i,:)' * derB(i,:);
end
