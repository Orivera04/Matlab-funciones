function x = playtune(str,cf,cb)
% Play musical tune.
% [x] = playtune(str,[cf],[cb])
%
% Notation:
% [CDEFGAB] keys, 5 full octaves
% [12345678] key/rest duration,
% with the default [1] semiquaver, [2] quaver, [4] crochet and [8] minim
% [#] sharp / [b] flat / [.] rest / [^] raise octave / [_] lower octave
%
% Examples:
% C major            -- playtune('^2CDEFGAB^C_BAGFEDC');
% F major            -- playtune('^2FGABb^CDEFEDC_BbAGF');
% B minor (harmonic) -- playtune('^2B^C#DEF#GA#BA#GF#EDC#_B');
% F# minor (melodic) -- playtune('^2F#G#AB^C#D#E#F#EDC#_BAG#F#');
% Doe-a-deer         -- playtune('^^6C2D6E2C4EC8E6D2EFFED8F.');
%
% Advanced features:
% CF is a (N,2) matrix where the first column contains the frequency and
%   the second column the corresponding scaling coefficient. The simplest
%   choice of CF would be cf = [1 1] which generates a pure sine wave. The
%   default CF is cf = [1 1; 1.001 0.33; 1.002 0.2; 0.999 0.33; 0.998 0.2]
%   which generates a tone resembling the flute.
% CB is a (1,9) vector containing the duration of that particular symbol (1-9).
%
% v2.0, Alan Tan (weechiat@gmail.com) 

if nargin < 2 | isempty(cf), cf = [1 1; 1.001 0.33; 1.002 0.2; 0.999 0.33; 0.998 0.2]; end
if nargin < 3 | isempty(cb), cb = [1:9]; end

% Set constants.
Fc = 65.4064;
Fs = 2^13;
Ts = 1/Fs;
Td = 0.1;
c1 = 2*pi*Fc;
c2 = 2.^([0:60]/12);

% Convert string to score.
d                   = -ones(1,length(str));
d(find(str == 'C')) = 0;
d(find(str == 'D')) = 2;
d(find(str == 'E')) = 4;
d(find(str == 'F')) = 5;
d(find(str == 'G')) = 7;
d(find(str == 'A')) = 9;
d(find(str == 'B')) = 11;
d(find(str == '^')) = 0;
d(find(str == '_')) = 0;
d(find(str == '.')) = 0;
u1                  = find(str == 'b');
d(u1-1)             = d(u1-1)-1;
u2                  = find(str == '#');
d(u2-1)             = d(u2-1)+1;
str([u1,u2])        = [];
d([u1,u2])          = [];

% Construct vector.
x  = [];
oc = 1;
Tu = Td;
t  = [Ts:Ts:Tu];
L  = length(t);
th = zeros(size(cf,1),1);
for k = 1:length(str)
   if d(k) == -1
      Tu = cb(str(k)-48)*Td;
      t  = [Ts:Ts:Tu];
      L  = length(t);
   else
      switch str(k),
      case '^',  oc       = oc+12;
      case '_',  oc       = oc-12;
      case '.',  x(end+L) = 0;
      otherwise
         wt           = c1*c2(oc+d(k))*t;
         x(end+(1:L)) = transpose(cf(:,2))*sin(cf(:,1)*wt+th(:,ones(1,L)));
         th           = rem(cf(:,1)*wt(end)+th,2*pi);
      end
   end
end

% Set output.
if ~nargout
   soundsc(x,Fs);
   clear x;
end
