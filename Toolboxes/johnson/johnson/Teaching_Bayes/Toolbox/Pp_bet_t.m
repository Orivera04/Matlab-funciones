function values=pp_bet_t(prob,parH,parK,data)
%
% PP_BET_T Test of the equality of two proportions using beta priors.
%	VALUES=PP_BET_T(PROB,PARH,PARK,DATA) gives a vector of the Bayes factor
%	and the probability of the hypothesis P1=P2, where PROB is the prior 
%	probability of the hypothesis, PARH is the vector of parameters of the 
%	beta density under the equality hypothesis, PARK is the vector of
%	parameters of the independent beta priors under the hypothesis that the
%	proportions are unequal, and DATA is the vector of numbers of successes 
%	and failures for the two samples.

a=parH(1); b=parH(2);
a1=parK(1); b1=parK(2); a2=parK(3); b2=parK(4);
s1=data(1); f1=data(2); s2=data(3); f2=data(4);

lbf=betaln(a+s1+s2,b+f1+f2)+betaln(a1,b1)+betaln(a2,b2)-...
    betaln(a,b)-betaln(a1+s1,b1+f1)-betaln(a2+s2,b2+f2);
bf=exp(lbf);

post=prob*bf/(prob*bf+1-prob);
values=[bf post];


