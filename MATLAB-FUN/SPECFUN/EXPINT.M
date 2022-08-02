function y = expint(x)
%EXPINT	Exponential integral function for n=1. 
%	Y = EXPINT(X) is the integral from X to Inf of (exp(-t)/t) dt.
%	For elements of X in [-38,2], EXPINT uses a series expansion  
%	representation (equation 5.1.10 from Abramowitz & Stegun).
%	For all other elements of X, EXPINT uses a continued fraction
%	representation (equation 5.1.22 in A&S).

%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	D. L. Chen  9-29-92
%       17 June 93 (jmike): changed 'ln' to 'log'.

%	References:
%	  [1] M. Abramowitz and I.A. Stegun, "Handbook of Mathematical
%		Functions", Dover Publications, 1965, Ch. 5.

if isempty(x)
    y = []; 

else
% make input and output matrices column vectors
colx = x(:);
coly = zeros(size(colx));

% figure out which algorithm to use by evaluating interpolating polynomial 
% at real(z)

p8 = -3.602693626336023e-09; 
p7 = -4.819538452140960e-07; 
p6 = -2.569498322115933e-05;
p5 = -6.973790859534190e-04; 
p4 = -1.019573529845792e-02; 
p3 = -7.811863559248197e-02;
p2 = -3.012432892762715e-01; 
p1 = -7.773807325735529e-01;
p0 =  8.267661952366478e+00;

r = real(x);
polyv = p8*r.^8 + p7*r.^7 + p6*r.^6 + p5*r.^5 + p4*r.^4 + p3*r.^3 + p2*r.*r + p1*r + p0;

% series expansion

k = find( abs(imag(x)) <= polyv );

if any(k)

   %initialization
   egamma=0.57721566490153286061;
   coly(k) = -egamma*ones(size(colx(k))) - log(colx(k));
   j=1;
   term = -colx(k);

   while any(abs(term) > (eps*abs(coly(k))))   
      	coly(k) = coly(k) - term;
	j = j + 1;
	term = j*log(-colx(k)) - sum(log(1:j)) - log(j);
	term = exp(term);
   end		% end of the while loop
 
   y = coly;

end                   % end of if statement

%continued fraction
%   note: am1, bm1 corresponds to A(j-1), B(j-1) of recursion formulae
%         am2, bm2 corresponds to A(j-2), B(j-2) of recursion formulae
%         a,b      corresponds to A(j), B(j) of recursion formulae

k = find( abs(imag(x)) > polyv );

n=1;				% we're calculating E1(x)

% initialization
am2= zeros(size(colx(k)));
bm2= ones(size(colx(k)));
am1= ones(size(colx(k)));
bm1= colx(k);
f= am1 ./ bm1;
oldf= Inf*ones(size(colx(k)));
j=2;

while any (abs(f-oldf) > (10*eps*abs(f)) )

% calculate the coefficients of the recursion formulas for j even
    alpha= n-1+(j/2);                          % note: beta= 1

    %calculate A(j), B(j), and f(j)
    a = am1 + alpha * am2;
    b = bm1 + alpha * bm2;

    % save new normalized variables for next pass through the loop
    %  note: normalization to avoid overflow or underflow
    am2 = am1 ./ b;
    bm2 = bm1 ./ b;
    am1 = a ./ b;
    bm1 = 1;

    oldf=f;
    f = am1;
    j = j+1;

% calculate the coefficients for j odd
    alpha= (j-1)/2;
    beta= colx(k);
    a = beta .* am1 + alpha * am2;
    b = beta .* bm1 + alpha * bm2;
    am2 = am1 ./ b;
    bm2 = bm1 ./ b;
    am1 = a ./ b;
    bm1 = 1;
    oldf=f;
    f = am1;
    j = j+1;

end		% end of the while loop
 
y(k)= exp(-colx(k)) .* f; 

% calculate the principle value for points on the negative real axis	
% using the continued fraction algorithm

cond1 = (real(colx)<=0)  & (imag(colx)==0); 
cond2 =  (colx > 2) | (colx < -38) ;
k = find( cond1&cond2 ); 
y(k) = y(k) - i*pi;

% resize answer to size of original matrix x
y = reshape(y,size(x,1),size(x,2));

end
