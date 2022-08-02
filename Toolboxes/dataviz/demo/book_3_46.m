%  book_3_46.m
%  calls jitter

load fly

plot(jitter(Temperature,1),jitter(FacetNumber,1),'o')
xlabel('Jittered Temperature (deg C)')
ylabel('Jittered Facet Number')
title('Fly')
