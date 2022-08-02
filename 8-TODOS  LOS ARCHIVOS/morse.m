function morse(varargin)

% MORSE converts text to playable morse code in wav format
% 
% SYNTAX
% morse(text)
% morse(text,file);
% 
% Description:
% 
%   If the wave file name is specified, then the funtion will output a wav
%   file with that file name.  If only text is specified, then the function
%   will only play the morse code wav file without saving it to a wav file.
%
% Examples:
% 
%   morse('Hello');
%   morse('How are you doing my friend?','morsecode.wav');
%
%   Copyright 2005 Fahad Al Mahmood
%   Version: 1.0 $  $Date: 05-Jun-2005

text = varargin{1};
if nargin==2
    file = varargin{2};
end

Fs=11025;
load wav;
Dit = wav(1106:2121);
ssp = wav(2121:3133);
Dah = wav(3133:6176);
lsp = wav(6176:23022);

% Defining Characters & Numbers
A = [Dit;ssp;Dah];
B = [Dah;ssp;Dit;ssp;Dit;ssp;Dit];
C = [Dah;ssp;Dit;ssp;Dah;ssp;Dit];
D = [Dah;ssp;Dit;ssp;Dit];
E = [Dit];
F = [Dit;ssp;Dit;ssp;Dah;ssp;Dit];
G = [Dah;ssp;Dah;ssp;Dit];
H = [Dit;ssp;Dit;ssp;Dit;ssp;Dit];
I = [Dit;ssp;Dit];
J = [Dit;ssp;Dah;ssp;Dah;ssp;Dah];
K = [Dah;ssp;Dit;ssp;Dah];
L = [Dit;ssp;Dah;ssp;Dit;ssp;Dit];
M = [Dah;ssp;Dah];
N = [Dah;ssp;Dit];
O = [Dah;ssp;Dah;ssp;Dah];
P = [Dit;ssp;Dah;ssp;Dah;ssp;Dit];
Q = [Dah;ssp;Dah;ssp;Dit;ssp;Dah];
R = [Dit;ssp;Dah;ssp;Dit];
S = [Dit;ssp;Dit;ssp;Dit];
T = [Dah];
U = [Dit;ssp;Dit;ssp;Dah];
V = [Dit;ssp;Dit;ssp;Dit;ssp;Dah];
W = [Dit;ssp;Dah;ssp;Dah];
X = [Dah;ssp;Dit;ssp;Dit;ssp;Dah];
Y = [Dah;ssp;Dit;ssp;Dah;ssp;Dah];
Z = [Dah;ssp;Dah;ssp;Dit;ssp;Dit];
period = [Dit;ssp;Dah;ssp;Dit;ssp;Dah;ssp;Dit;ssp;Dah];
comma = [Dah;ssp;Dah;ssp;Dit;ssp;Dit;ssp;Dah;ssp;Dah];
question = [Dit;ssp;Dit;ssp;Dah;ssp;Dah;ssp;Dit;ssp;Dit];
slash_ = [Dah;ssp;Dit;ssp;Dit;ssp;Dah;ssp;Dit];
n1 = [Dit;ssp;Dah;ssp;Dah;ssp;Dah;ssp;Dah];
n2 = [Dit;ssp;Dit;ssp;Dah;ssp;Dah;ssp;Dah];
n3 = [Dit;ssp;Dit;ssp;Dit;ssp;Dah;ssp;Dah];
n4 = [Dit;ssp;Dit;ssp;Dit;ssp;Dit;ssp;Dah];
n5 = [Dit;ssp;Dit;ssp;Dit;ssp;Dit;ssp;Dit];
n6 = [Dah;ssp;Dit;ssp;Dit;ssp;Dit;ssp;Dit];
n7 = [Dah;ssp;Dah;ssp;Dit;ssp;Dit;ssp;Dit];
n8 = [Dah;ssp;Dah;ssp;Dah;ssp;Dit;ssp;Dit];
n9 = [Dah;ssp;Dah;ssp;Dah;ssp;Dah;ssp;Dit];
n0 = [Dah;ssp;Dah;ssp;Dah;ssp;Dah;ssp;Dah];

text = upper(text);
vars ={'period','comma','question','slash_'};
morsecode=[];
for i=1:length(text)
    if isvarname(text(i))
    morsecode = [morsecode;eval(text(i))];
    elseif ismember(text(i),'.,?/')
        x = findstr(text(i),'.,?/');
        morsecode = [morsecode;eval(vars{x})];
    elseif ~isempty(str2num(text(i)))
        morsecode = [morsecode;eval(['n' text(i)])];
    elseif text(i)==' '
        morsecode = [morsecode;ssp;ssp;ssp];
    end
    morsecode = [morsecode;lsp];
end
if exist('file','var')
    wavwrite(morsecode,11025,16,file);
else
    wavplay(morsecode);
end
