function M = morse_tree_extended
% MORSE_TREE_EXTENDED
% M = morse_tree is a cell array of cell arrays, the binary
% tree for the Morse code of the 26 Latin characters.
%
% M = morse_tree_extended is a larger cell array of cell arrays,
% the binary tree for the Morse code of the 26 Latin characters
% plus digits, punctuation marks, and several non-Latin characters.

% Non-Latin characters: À Ä Ð Ñ Ö × Ü
% Use char(nnn) if the quoted character does not work.
agrave  = 'À';  % char(192)
aumlaut = 'Ä';  % char(196)
dstroke = 'Ð';  % char(208)
enyay   = 'Ñ';  % char(209)
oumlaut = 'Ö';  % char(214)
cross   = '×';  % char(215), substitute for ch, no Unicode character.
uumlaut = 'Ü';  % char(220)

% Level 6
period  = {'.' {} {}};
comma   = {',' {} {}};
minus   = {'-' {} {}};
atsign  = {'@' {} {}};
quest   = {'?' {} {}};
semi    = {';' {} {}};
colon   = {':' {} {}}; 

% Level 5
d0 = {'0' {} {}};
d1 = {'1' {} {}};
d2 = {'2' {} {}};
d3 = {'3' {} {}};
d4 = {'4' {} {}};
d5 = {'5' {} {}};
d6 = {'6' {} minus};
d7 = {'7' {} {}};
d8 = {'8' colon {}};
d9 = {'9' {} {}};
znull = {'' {} comma};
cnull = {'' semi {}};
plus = {'+' {} period};
ag = {agrave atsign {}};
ds = {dstroke quest {}};
en = {enyay {} {}};

% Level 4
h = {'H' d5 d4};
v = {'V' {} d3};
f = {'F' {} {}};
um = {uumlaut ds d2};
l = {'L' {} {}};
am = {aumlaut plus {}};
p = {'P' {} ag};
j = {'J' {} d1};
b = {'B' d6 {}};
x = {'X' {} {}};
c = {'C' {} cnull};
y = {'Y' {} {}};
z = {'Z' d7 znull};
q = {'Q' {} en};
om = {oumlaut d8 {}};
ch = {cross d9 d0};

% Level 3
s = {'S' h v};
u = {'U' f um};
r = {'R' l am};
w = {'W' p j};
d = {'D' b x};
k = {'K' c y};
g = {'G' z q};
o = {'O' om ch};

% Level 2
i = {'I' s u};
a = {'A' r w};
n = {'N' d k};
m = {'M' g o};

% Level 1
e = {'E' i a};
t = {'T' n m};

% Level 0
M = {'' e t};
