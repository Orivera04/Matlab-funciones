 function [Gm,Pm,Wcg,Wcp] = margins(num,den,value);
% MARGINS : Analytically calculates ALL the Phase and Gain Margin(s)
%
%function [Gm,Pm,Wcg,Wcp] = margins(num,den);
%function [G,P,Wg,Wp] = margins(num,den,value);
%
% analytically finds all the Phase and Gain Margin(s) (if any) 
% same output syntax as the MATLAB margin command.
%
% Optional : Value >> -(10^(0/20)) yields Gain and Phase margin
%                     -(10^(3/20)) yields 3db point (Bandwidth)
%
% See also: polymag, polyangl
[num,den] = polysbst(num,den,[sqrt(-1) 0],1); % GO FROM S TO JW
%
% FIND THE PHASE MARGIN AND ITS FREQUENCY
Wcp = polymag(num,den,1);
Wcp = Wcp(find(real(Wcp) > 1e-15)); % ONLY Positive W.
Wcp = abs(Wcp(find(real(Wcp) > 100*abs(imag(Wcp))))); % NO Complex W
val = log(polyval(num,Wcp)./polyval(den,Wcp));
ii = find(abs(real(val)) < 1e-3); % eliminate false unity gains
Wcp = Wcp(ii); Pm = 180+imag(val(ii))*180/pi;
Pm = Pm-360*(Pm > 180); % adjustment from -pi/pi to -2*pi/0
%
% FIND THE GAIN MARGIN AND ITS FREQUENCY
Wcg = polyangl(num,den,-180);
Wcg = Wcg(find(real(Wcg) > 1e-15)); % ONLY Positive W.
Wcg = abs(Wcg(find(real(Wcg) > 100*abs(imag(Wcg))))); % NO Complex W
val = polyval(num,Wcg)./polyval(den,Wcg);
ii = find(pi-abs(imag(log(val))) < 1e-2); % eliminate false -180's
Wcg = Wcg(ii); Gm = 1.0./abs(val(ii));
