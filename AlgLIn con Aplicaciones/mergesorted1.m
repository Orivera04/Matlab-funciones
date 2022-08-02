clc,clear all
% % Merging two sorted vectors using 'mergesorted' function
a=input('vector a= ')
b=input('vector b= ')
time = cputime;
c=mergesorted(a,b);
c1=sort(c)
time_mergesorted = cputime-time

% % Merging two sorted vectors using MATLAB built in functions
c2=sort([a,b])


