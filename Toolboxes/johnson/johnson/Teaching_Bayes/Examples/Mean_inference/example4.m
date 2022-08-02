% EXAMPLE4.m
% Learning about a normal mean
% A test for a mean [Albert (1996), p. 120].

% Learning about a N(M, s2) population with s2 known.
% A Bayesian test of hypothesis that M=M0

M0=170;  % input value of M to be tested
prob=.5;  % input prior probability of M
T=[.5 1 2 4 8];  % under alternative hypothesis M is assigned
                 % N(M0, t) prior.  T is column of plausible
                 % values of t

data=[182 172 173 176 176 180 173 174 179 175]; % observed data
xbar=mean(data);  % sample mean
n=length(data);   % sample size
std=3;            % known population standard deviation
data_input=[xbar n std];

m_norm_t(M0,prob,T,data_input)

% first column contains values of the Bayes factor in support of
% M=M0 and second column contains posterior probabilities of M=M0
% corresponding to values in T 
