function secder = valX2der(val, secder)

for i = 1:size(val,1)
    secder(i,:,:) = val(i) .* secder(i,:,:);
end
