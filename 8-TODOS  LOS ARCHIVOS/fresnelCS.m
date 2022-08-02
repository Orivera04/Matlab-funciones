function [FresnelC,FresnelS] = fresnelCS(y)

% This function calculates the fresnel cosine and sine integrals.
% Input:
% y = values for which fresnel integrals have to be evaluated
%
% Output:
% FresnelC = fresnel cosine integral of y
% FresnelS = fresnel sine integral of y
%
% Adapted from:
% Atlas for computing mathematical functions : an illustrated guide for
% practitioners, with programs in C and Mathematica / William J. Thompson.
% New York : Wiley, c1997.
%
% Author: Venkata Sivakanth Telasula
% email: sivakanth.telasula@gmail.com
% date: August 11, 2005
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fn = [0.49999988085884732562 1.3511177791210715095 ...
      1.3175407836168659241 1.1861149300293854992 ...
      0.7709627298888346769 0.4173874338787963957 ...
      0.19044202705272903923 0.06655998896627697537 ...
      0.022789258616785717418 0.0040116689358507943804 ...
      0.0012192036851249883877];
  
fd = [1.0 2.7022305772400260215 ...
      4.2059268151438492767 4.5221882840107715516 ...
      3.7240352281630359588 2.4589286254678152943 ...
      1.3125491629443702962 0.5997685720120932908 ...
      0.20907680750378849485 0.07159621634657901433 ...
      0.012602969513793714191 0.0038302423512931250065];
  
gn = [0.50000014392706344801 0.032346434925349128728 ...
      0.17619325157863254363 0.038606273170706486252...
      0.023693692309257725361 0.007092018516845033662...
      0.0012492123212412087428 0.00044023040894778468486...
     -8.80266827476172521e-6 -1.4033554916580018648e-8...
      2.3509221782155474353e-10];
  
gd  = [1.0 2.0646987497019598937 2.9109311766948031235 ...
       2.6561936751333032911 2.0195563983177268073...
       1.1167891129189363902 0.57267874755973172715...
       0.19408481169593070798 0.07634808341431248904...
       0.011573247407207865977 0.0044099273693067311209 ...
      -0.00009070958410429993314];

FresnelC = zeros(size(y));FresnelS = zeros(size(y));
for j = 1:length(y)
    x = y(j);
if ( x < 1.0 )
  t = -(pi/2*x.*x).^2;
 
%  /* Cosine integral series */
 twofn = 0.0;  fact = 1.0;  denterm = 1.0; numterm = 1.0; sum = 1.0; ratio = 10.0; 
 
 while ( ratio > eps )
  twofn = twofn + 2.0;
  fact = fact*twofn*(twofn-1.0);
  denterm = denterm + 4.0;
  numterm = numterm*t;
  term = numterm/(fact*denterm);
  sum = sum+term;
  ratio = abs(term/sum);
 end
    
 FresnelC(j) =  x*sum;
 
%  /* Sine integral series */
 twofn = 1.0;  fact = 1.0;  denterm = 3.0;  numterm = 1.0;  sum = 1.0/3.0;
 ratio = 10.0;
 
 while ( ratio > eps )
  
  twofn = twofn+2.0;
  fact = fact*twofn*(twofn-1.0);
  denterm = denterm+4.0;
  numterm = numterm*t;
  term = numterm/(fact*denterm);
  sum = sum+term;
  ratio = abs(term/sum);
 end
 
FresnelS(j) =  pi/2*x.*x.*x.*sum;
 
elseif ( x < 6.0 )
%  	{ /* Rational approximation for  f   */
 	sumn =  0.0;
 	sumd =  fd(12);
 	for k=11:-1:1
 	 sumn = fn(k)+x*sumn;
 	 sumd = fd(k)+x*sumd;
    end
 	f = sumn/sumd;
%  	/* Rational approximation for  g   */
 	sumn =  0.0;
 	sumd =  gd(12);
 	for k=11:-1:1
 	 sumn = gn(k)+x*sumn;
 	 sumd = gd(k)+x*sumd;
    end
 	g = sumn/sumd;
 	U = pi/2*x.*x;
    
  SinU = sin(U);
  CosU = cos(U);
  FresnelC(j) = 0.5+f*SinU-g*CosU;
  FresnelS(j) = 0.5-f*CosU-g*SinU;
%   end
  
else
  
%   /* x >= 6; asymptotic expansions for  f  and  g */
  t = -(pi*x.*x)^-2.0;
%  	/* Expansion for  f   */
 	numterm = -1.0;   	term = 1.0;  	sum = 1.0;  	oldterm = 1.0;
	ratio = 10.0; 	eps10 = 0.1*eps;
    
 	while ( ratio > eps10 )
  		  numterm = numterm+4.0;
          term = term*numterm*(numterm-2.0)*t;
          sum = sum + term;
          absterm = abs(term);
          ratio = abs(term/sum);
 	  if ( oldterm < absterm )
          disp('\n\n !!In FresnelCS f not converged to eps');
          ratio = eps10;
      end
 	  oldterm = absterm;
    end
    
  f = sum/(pi*x);
%   /* Expansion for  g   */
 	numterm = -1.0;   term = 1.0; 	sum = 1.0; 	oldterm = 1.0;	ratio = 10.0;
	eps10 = 0.1*eps;
    
 	while ( ratio > eps10 )
  	 	  numterm = numterm+ 4.0;
          term = term*numterm*(numterm+2.0)*t;
          sum = sum+term;
          absterm = abs(term);
          ratio = abs(term/sum);
          
 	  if ( oldterm < absterm )
 	   
 	   disp('\n\n!!In FresnelCS g not converged to eps');
 	   ratio = eps10;
      end
 	  oldterm = absterm;
    end
    
    g = sum/((pi*x)^2*x);
	U = pi/2*x*x;
  SinU = sin(U);
  CosU = cos(U);
  FresnelC(j) = 0.5+f*SinU-g*CosU;
  FresnelS(j) = 0.5-f*CosU-g*SinU;
end
end

% EOF