% EXAMPLE3.m
% Learning about a normal mean
% Assesses normal prior density [Albert (1996), p. 116].

% Learning about a N(M, s2) population with s2 known.
% Assessing normal prior density for M.

perc1=[.5 174];  % One believes that P(M <= 174) = .5
perc2=[.9 180];  % One believes that P(M <= 180) = .9

par=normal_s(perc1,perc2)  % finds mean and standard deviation
                           % of matching normal density

