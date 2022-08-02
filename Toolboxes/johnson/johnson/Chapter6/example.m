% EXAMPLE.M
% -------------------------------------------------------------------
% MATLAB 5 ROUTINES FOR COMPUTATIONS IN CHAPTER 6
%--------------------------------------------------------------------  
%  Jim Albert - June 14, 1998
%-------------------------------------------------------------

%---------------------------------------------------------------------
% plot some sample item response curves
%
% let theta (latent ability) take 50 values equally spaced between -3 and 4

theta=linspace(-3,3,50);

%---------------------------------------------------------------------
% computes P(y=1 | theta) for a=1, b=0
% plots probability as a function of theta

figure(1)
p1=ir_curve(theta,1,0);              
plot(theta,p1);
xlabel('LATENT ABILITY'); ylabel('PROBABILITY OF CORRECT RESPONSE')

%---------------------------------------------------------------------
% plots three item response curves on same scale
%

figure(2)
p2=ir_curve(theta,1,-1);
p3=ir_curve(theta,1,1);
plot(theta,p1,'-',theta,p2,':',theta,p3,'--')
xlabel('LATENT ABILITY'); ylabel('PROBABILITY OF CORRECT RESPONSE')
legend('a=1,b=0','a=1,b=-1','a=1,b=1',2)

%---------------------------------------------------------------------
% student ratings dataset described in Chapter 6
% ratings.dat is a 120 by 107 matrix of 0's and 1's
%    - rows correspond to the 120 students that are judged
%    - columns correspond to the 107 judges who rated students
%    - matrix value of 1 corresponds to a correct response, 0 to an incorrect
%    - response

load ratings.dat           % load data

%---------------------------------------------------------------------
% fit Bayesian two-parameter item response model with probit link
% assume:
%     1.  theta_1, ..., theta_n are independent N(0, 1)
%     2.  a_1, ..., a_k are independent N(0, s_a)
%     3.  b_1, ..., b_k are independent N(0, s_b)
%     m iterations of Gibbs sampling
% output is matrix av of simulated values of a, matrix bv of simulated values of
% b, vector th_m of posterior means of theta, and vector th_s of standard deviations of
% theta

s_a=1; s_b=1; m=500;
[av,bv,th_m,th_s]=item_r(ratings,s_a,s_b,m);

%---------------------------------------------------------------------
% compute simulated sample of biserial correlation r and probability of 
% correct response p

r=av./sqrt(1+av.^2);
p=phi(-bv./sqrt(1+av.^2));

%---------------------------------------------------------------------
% compute posterior means of r and p
% construct scatterplot where plotting points are labels of judges

figure(4)
k=size(ratings,2);
t='1'; for i=2:k,t=str2mat(t,num2str(i));end % matrix containing labels
plot(mean(p),mean(r),'.')
text(mean(p),mean(r),t)
xlabel('P');ylabel('R')

%---------------------------------------------------------------------
% construct errorbar graphs of the slope parameters a
% 5th, 50th, and 95th percentiles of all of the parameters stored in the matrix a_summ

figure(5)
a_summ=plotpost(av,'y');
xlabel('JUDGE NUMBER');ylabel('SLOPE PARAMETER')

%---------------------------------------------------------------------
% posterior estimation of item response curve
%
% theta - vector of values of latent trait
% av - matrix of simulated values of item response parameters a
% gv - matrix of simulated values of item response parameters b
% 
% in the following, pr is the matrix of medians of phi(a theta - b),
% lo is matrix of 5th percentiles of phi(a theta - b) and hi is matrix
% of 95th percentiles of phi(a theta - b) (rows correspond to theta and columns
% to items)

theta=linspace(-3,3,20);
[pr,lo,hi]=irtpost(av,bv,theta);

%---------------------------------------------------------------------
% graph posterior density of item response curve for judge 25

figure(6)
plot(theta,pr(:,25),'-',theta,lo(:,25),':',theta,hi(:,25),':')
xlabel('LATENT TRAIT');ylabel('PROBABILITY')

%---------------------------------------------------------------------
% ALTERNATIVE FITS
%---------------------------------------------------------------------

%---------------------------------------------------------------------
% fit of 2-parameter model with logistic link function
% slopes are independent N(0, sa); intercepts are independent N(0, sb)
% m is number of iterations in MCMC run

sa=1; sb=1; m=500;
[av,bv,th_m,th_s]=l_itemr(ratings,sa,sb,m);

%---------------------------------------------------------------------
% fit of 1-parameter model with probit link
% item intercepts are independent N(0, sb)
% m is number of iterations in MCMC run

sb=1; m=500;
[bv,th_m,th_s]=item_r1(ratings,sb,m);

%---------------------------------------------------------------------
% fit of 2-parameter probit model with exchangeable prior (section 6.10)
% ab - vector [a b] of hyperparameters of prior on variance s^2
% m is number of iterations in MCMC run
% in output, av and bv are matrices of simulated values of item parameters,
% th_m and th_s are means and standard deviations of latent traits, and av_m
% and av_s2 are vectors of simulated values of second-stage hyperparameters mu
% and tau^2.

ab=[1 1]; m=500;
[av,bv,th_m,th_s,av_m,av_s2]=item_r_h(ratings,ab,m);
