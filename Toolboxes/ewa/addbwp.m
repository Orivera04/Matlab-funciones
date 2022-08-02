% addbwp.m - add 3-dB angle width in polar plots
%
% Usage: addbwp(Dth, style)
%        addbwp(Dth)        (equivalent to style = '--')
%
% phi = desired azimuthal angle in degrees
% style = linestyle, e.g., '--'
% 
% see also ADDCIRC, ADDLINE

% S. J. Orfanidis - 1997 - www.ece.rutgers.edu/~orfanidi/ewa

function addbwp(Dth, style)

if nargin==0, help addbwp; return; end
if nargin==1, style = '--'; end

addray(90-Dth/2,style);
addray(90+Dth/2,style);

