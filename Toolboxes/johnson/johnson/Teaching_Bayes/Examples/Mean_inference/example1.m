% EXAMPLE1.m
% Learning about a normal mean
% Using discrete prior [Albert (1996), p. 113].

% Learning about a N(M, s2) population with s2 known.
% We suppose that M has discrete prior distribution and
% we observe a sample of n observations.  Want to compute
% the posterior distribution of M.

M=[174 176 178];  % possible values of M
prior=[1 1 1]/3;  % corresponding prior probabilities

data=[182 172 173 176 176 180 173 174 179 175]; % observed data
xbar=mean(data);  % sample mean
n=length(data);   % sample size
std=3;            % known population standard deviation
data_input=[xbar n std];

post=m_disc(M,prior,data_input) % computes posterior probabilities
