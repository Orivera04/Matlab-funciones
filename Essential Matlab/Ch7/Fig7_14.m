t = 1790:2000;
P = 197273000 ./ (1+exp(-0.03134*(t-1913.25)));
plot(t, P, 'k'), hold, xlabel('Year'), ylabel('Population size')
census = [3929 5308 7240 9638 12866 17069 23192 31443 38558 ...
          50156 62948 75995 91972 105711 122775 131669 150697];
census = 1000 * census;
plot(1790:10:1950, census, 'o'), hold off