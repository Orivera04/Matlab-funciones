% 	GEOMETRIC PRODUCT
GAfigure; clc; %/
% 	GEOMETRIC PRODUCT
%
global a b; %/
clf; %/
a = e1 + e3;
b = e1 + e2; %%
%	We use * to denote the geometric product in GABLE:
a*b %w 
%	Note: scalar + bivector ! 
GAprompt; %/
%	Order matters!
b*a    %w
GAprompt; %/
%	Square of a vector is scalar
b*b    %w
%	Square of a bivector is negative
(e1^e2)*(e1^e2)    %w
%	Every non-null vector has an inverse
1/b    %w
b*(1/b)    %w
GAprompt; %/
% 	Inverse formula: 
b/(b*b)    %w
GAprompt; %/
% 	Inverse of unit vector:
1/e1    %w
GAprompt; %/
%	The geometric product is invertible; 
%	From (a*b) and b, retrieve a = e1+e3 :
a*b
b
(a*b)/b    %w
