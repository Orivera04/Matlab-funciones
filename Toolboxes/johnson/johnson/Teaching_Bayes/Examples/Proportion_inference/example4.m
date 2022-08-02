% EXAMPLE4.m
% -------------------------------------------
% Learning about a proportion 
% Assessing a beta prior [Albert (1996), p. 53].

r=.3;          % probability of a future success
rplus=.32;     % probability of a second success conditional on a
               % first success
 
beta_par=beta_sel(r,rplus)  % gives parameters of matching
                            % beta density
                                          
                                          