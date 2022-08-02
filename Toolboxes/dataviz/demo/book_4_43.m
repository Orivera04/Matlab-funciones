%  book_4_43.m
%  calls jitter

load galaxy

plot(jitter(EastWest,1),jitter(NorthSouth,1),'o')
xlabel('Jittered East-West Coordinate (arcsec)')
ylabel('Jittered North-South Coordinate (arcsec)')
title('Galaxy')
axis image
