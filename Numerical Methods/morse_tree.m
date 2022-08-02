function M = morse_tree
% MORSE_TREE
% M = morse_tree is a cell array of cell arrays, the binary
% tree for the Morse code of the 26 Latin characters.
%
% M = morse_tree_extended is a larger cell array of cell arrays,
% the binary tree for the Morse code of the 26 Latin characters
% plus digits, punctuation marks, and several non-Latin characters.
%
%                     _____  root _____
%                   /                   \
%               _ E _                   _ T _
%            /         \             /         \
%           I           A           N           M
%         /   \       /   \       /   \       /   \
%        S     U     R     W     D     K     G     O
%       / \   /     /     / \   / \   / \   / \
%      H   V F     L     P   J B   X C   Y Z   Q
%

global extend
if extend==1
   M = morse_tree_extended;
   return
end

% Level 4
h = {'H' {} {}};
v = {'V' {} {}};
f = {'F' {} {}};
l = {'L' {} {}};
p = {'P' {} {}};
j = {'J' {} {}};
b = {'B' {} {}};
x = {'X' {} {}};
c = {'C' {} {}};
y = {'Y' {} {}};
z = {'Z' {} {}};
q = {'Q' {} {}};

% Level 3
s = {'S' h v};
u = {'U' f {}};
r = {'R' l {}};
w = {'W' p j};
d = {'D' b x};
k = {'K' c y};
g = {'G' z q};
o = {'O' {} {}};

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
