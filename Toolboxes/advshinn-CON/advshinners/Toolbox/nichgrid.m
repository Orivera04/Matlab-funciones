 function [x,y] = nichgrid(g,a,b,n);
% NICHGRID : Nichols Chart is displayed/returned for given grid values
%
%function [x,y] = nichgrid(g,a,b,n);
%
% displays a Nichols chart, if a grid value (g) is specified, with:
%     g = grid values for axis (in DEGREES & DB)
%     a = angles (in DEGREES, -180<a<0)
%     b = gains (in DB)
%     n = interpolation value (optional, default=none)
% optional return values:
%     x = phase values
%     y = magnitude values (in Db)
[c,max] = computer;  % make sure MATLAB can handle max size!
if ( max < length(a)*length(b) ), x = NaN; y=NaN; else
  z = exp(sqrt(-1)*a(:)*pi/180)*exp(b(:)'*log(10)/20);
  x = imag(log(z./(1-z)))*180/pi; y = 20*log10(abs(z./(1-z)));
end;
if ( isempty(g) ), else     % Is a plot requested ??
  axis(g); plot(g(1:2),g(3:4),'.'); grid; axis(g);
  xlabel('Open-Loop Phase (DEGREES)');
  ylabel('Open-Loop Gain (DB)');
  if ( nargin < 3 ), n = 1; end;
  if ( isempty(a) ), a = -[.25:.25:1 2 5 10:10:170 179.999]; end;
  if ( isempty(b) ), b = [-24 -12 -9 -7 -5:-1 -.5:.25:.5 1:5 7 9 12]; end;
  if ( n == 1 ), aa = a; bb = b; else
  if (max > n*length(a)), aa=crosses(a,1:1/n:length(a)); aa=aa'; end;
  if (max > n*length(b)), bb=crosses(b,1:1/n:length(b)); bb=bb'; end;
  end;
  if ( max > length(aa)*length(b) )
      z = exp(sqrt(-1)*aa(:)*pi/180)*exp(b(:)'*log(10)/20);
      xx = imag(log(z./(1-z)))*180/pi; yy = 20*log10(abs(z./(1-z)));
      hold on; plot(xx,yy,'k--',-360-xx,yy,'k--'); hold off;
  else
    for ii = 1:length(b);
      z = exp(sqrt(-1)*aa(:)*pi/180)*exp(b(ii)'*log(10)/20);
      xx = imag(log(z./(1-z)))*180/pi; yy = 20*log10(abs(z./(1-z)));
      hold on; plot(xx,yy,'k--',-360-xx,yy,'k--'); hold off;
    end;
  end;
  if ( max > length(a)*length(bb) )
    z = exp(sqrt(-1)*a(:)*pi/180)*exp(bb(:)'*log(10)/20);
    xx = imag(log(z./(1-z)))*180/pi; yy = 20*log10(abs(z./(1-z)));
    hold on; plot(xx',yy','k-.',-360-xx',yy','k-.'); hold off;
  else
    for ii = 1:length(a);
      z = exp(sqrt(-1)*a(ii)*pi/180)*exp(bb(:)'*log(10)/20);
      xx = imag(log(z./(1-z)))*180/pi; yy = 20*log10(abs(z./(1-z)));
      hold on; plot(xx',yy','k-.',-360-xx',yy','k-.'); hold off;
    end;
  end;
end;
