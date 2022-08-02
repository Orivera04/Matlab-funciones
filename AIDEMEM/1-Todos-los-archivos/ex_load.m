clear all
a = 3;
b = 1:5;
c = 'azerty';
whos
save fich.mat a b c
clear all
s = load('fich.mat');
who
s