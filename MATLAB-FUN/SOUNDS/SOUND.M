function sound(y,fs)
%SOUND	Convert vector into sound.
%	SOUND(Y) sends the signal in vector Y out the speaker on SPARC, HP,
%	SGI, PC,  and Macintosh computers. The vector is autoscaled to provide
%	maximum amplitude.
%
%	The sound is played at the default sample rate. On the SPARC, the
%	sample rate is fixed at 8192 Hz. On the Macintosh, the default
%	sample rate is 22.255K Hz.
%
%	SOUND(Y,FS), on the Macintosh, PC, and SGI, plays the sound at a sample
%	frequency of FS Hz.
%
%	Vector Y is automatically scaled so that the maximum and minimum values 
%	in Y correspond to the maximum and minimum input ranges allowed by the
%	sound hardware. On the Macintosh and the SGI, the volume control on the
%	Control Panel determines the final sound level.
%
%	See also SAXIS, AUWRITE, AUREAD, WAVREAD, WAVWRITE.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

global SAXIS_SCALE
global SAXIS_LIM
v = saxis;
ymin = min(y(:));
ymax = max(y(:));
if ~strcmp(SAXIS_SCALE,'auto')
  smin = v(1);
  smax = v(2);
else % auto-scale
  smin = ymin;
  smax = ymax;
  if smin == smax
    smax = smax + 1;
  end
  SAXIS_LIM = [smin smax];
end
c = computer;
% Scale y's values between [smin smax] onto [-1 1].
slope = 2/(smax-smin);
intercept = (smin+smax)/(smin-smax);
y(:) = slope*y+intercept;
if (strcmp(c,'SUN4') | strcmp(c,'HP700') | strcmp(c,'SOL2'))
  auwrite(y);
elseif (strcmp(c(1:3),'MAC') | strcmp(c,'NEXT') | strcmp(c,'SGI'))
  if nargin == 1
    playsound(y)  % Uses MEX file in the case of NEXT and SGI
  else
    playsound(y,fs)
  end
elseif (strcmp(c(1:2),'PC'))
  x=y+1;
  x=x*(128);
  x=floor(x);
  if nargin < 2
    playwave(x,8192);
  else
    playwave(x,fs)
  end
else
  error('Sound is not currently supported on this hardware platform.')
end
