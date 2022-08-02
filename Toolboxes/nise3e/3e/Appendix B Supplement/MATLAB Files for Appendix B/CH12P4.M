% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
%
% Control Systems Engineering Toolbox Version 3.0 
% Copyright © 2000 by John Wiley & Sons, Inc.
%
% (ch12p4) Example 12.5: We can design observer gains using the command
% l = acker(A',C',poles)'. Notice, we use the transpose of the system
% matrix (A) and output matrix  (C) along with the desired poles (poles).
% Let us look at Example 12.5 in the text.

'(ch12p4) Example 12.5'             % Display label.
numg=[1 4];                         % Define numerator of G(s).
deng=poly([-1 -2 -5]);              % Define denominator of G(s).
'G(s)'                              % Display label.
G=tf(numg,deng)                     % Create and display G(s).
[Ac,Bc,Cc,Dc]=tf2ss(numg,deng);     % Transform G(s) to controller 
                                    % canonical form in state space.
Ao=Ac';                             % Transform Ac to observer canonical 
                                    % form.
Bo=Cc';                             % Transform Bc to observer canonical 
                                    % form.
Co=Bc';                             % Transform Cc to observer canonical 
                                    % form.
Do=Dc;                              % Transform Dc to observer canonical
                                    % form.
r=roots([1 2 5])                    % Find the controller-compensated 
                                    % system poles.
poles=10*[r' 10*real(r(1))]         % Make observer poles 10x bigger.
lp=acker(Ao',Co',poles)'            % Find the observer gains in observer
                                    % canonical form.
