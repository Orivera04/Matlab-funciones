% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
%
% Control Systems Engineering Toolbox Version 3.0 
% Copyright © 2000 by John Wiley & Sons, Inc.
%
% ch13sp3 (Example 13.4)     MATLAB's Symbolic Math Toolbox  can be 
% used to find the z-transform of a transfer function, G(s), in cascade 
% with a z.o.h. Two new commands are introduced. The first, compose(f,g), 
% allows a variable g to replace the variable t in f(t). We use this command 
% to replace t in g2(t) with nT before taking the z-transform. The other 
% new command is subs(S,old,new). Subs stands for symbolic substitution. 
% Old is a variable contained in S. New is a numerical or symbolic quantity 
% to replace old. We use subs to replace T in G(z) with a numerical value. 
% To find the z-transform of a transfer function, G(s), in cascade with a 
% z.o.h using MATLAB's Symbolic Math Toolbox, we perform the following 
% steps: (1) Construct G2(s)=G(s)/s, (2) Find the inverse Laplace transform 
% of G2(s), (3) Replace t with nT in g2(t), (4) Find G(z) = (1-z^-1)G2(z), 
% (5) Substitute a numerical value for T. Let us solve Example 13.4 using 
% MATLAB's Symbolic Math Toolbox.

'(ch13sp3) Example 13.4'     % Display label.
syms s z n T                 % Construct symbolic objects for 
                             % 's', 'z', 'n',and 'T'.
G2s=(s+2)/(s*(s+1));         % Form G2(s) = G(s)/s.
'G2(s)=G(s)/s'               % Display label.
pretty(G2s)                  % Pretty print G2(s).
'g2(t)'                      % Display label.
g2t=ilaplace(G2s);           % Find g2(t).
pretty(g2t)                  % Pretty print g2(t).
g2nT=compose(g2t,n*T);       % Find g2(nT).
'g2(nT)'                     % Display label.
pretty(g2nT)                 % Pretty print g2(nT).
Gz=(1-z^-1)*ztrans(g2nT);    % Find G(z) = (1-z^-1)G2(z).
Gz=simplify(Gz);             % Simplify G(z).           
'G(z)=(1-z^-1)G2(z)'         % Display label.
pretty(Gz)                   % Pretty print G(z).
Gz=subs(Gz,T,0.5);           % Let T = 0.5 in G(z).
Gz=vpa(simplify(Gz),4);      % Simplify G(z) and evaluate numerical
                             % values to 4 places.
'G(z) evaluated for T=0.5'   % Display label.
pretty(Gz)                   % Pretty print G(z) with numerical values.
