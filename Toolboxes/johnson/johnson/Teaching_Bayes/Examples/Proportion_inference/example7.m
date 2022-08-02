% EXAMPLE7.m
% -------------------------------------------
% Learning about a proportion 
% Inference using a histogram prior [Albert (1996), p. 65].

% The prior places probabilities .4, .4, .15, .05 on the
% intervals (.2, .25), (.25, .3), (.3, .35), (.35, .4).
% You observe 4 successes and 36 failures.

mids=[.225 .275 .325 .375];  % vector of midpoints of intervals
prior=[.4 .4 .15 .05];       % prior probs assigned to intervals
data=[4 36];                 % number of successes and failures
num=1000;                    % size of simulation sample in 
                             % performing computation
                           
post=p_hist_p(mids,prior,data,num) % vector of posterior probabilities
                                   % of intervals
                                          