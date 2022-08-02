function [ma,mi]=findextrema(a)

% FINDEXTREMA - finds minima and maxima of data
%
% If 'y' is the data the function finds the maximas 'ma' and minimas 'mi'.
% The x-position of the extrema are interpolated.
%
% Usage: [ma,mi]=findextrema(y);
%
% Example:
%    x=-10:0.1:10; y=sin(x);
%    [ma,mi]=findextrema(y);
%    plot(y); hold on; plot(ma,y(round(ma)),'ro'); plot(mi,y(round(mi)),'gs'); hold off;
%

a=gradient(a);
ad=diff(0.5*sign(a)); p=find(abs(ad)==1); %find position of signum change
if isempty(p) ma=[]; mi=[]; return; end
zp=p+a(p)./(a(p)-a(p+1));	%linear interpolate zero crossing

mip=find(ad(p)==1); map=find(ad(p)==-1);
mi=zp(mip); ma=zp(map);
