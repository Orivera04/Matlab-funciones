% EXAMPLE2.m
% Learning about a normal mean
% Using continuous vague prior [Albert (1996), p. 124].

% Learning about a N(M, s2) population with both M and
% s2 unknown.  Assign the usual vague prior to (M, s2)
% proportional to 1/s2.

data=[182 172 173 176 176 180 173 174 179 175]; % observed data
num=1000;    % size of simulation sample of computation

[m_sim,s_sim]=m_cont(data,num);

% m_sim is vector containing simulated sample from marginal posterior
% density of M and s_sim contains sample from marginal posterior
% density of standard deviation s=sqrt(s2)