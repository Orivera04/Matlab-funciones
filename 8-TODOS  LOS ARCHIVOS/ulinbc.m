function [u,ux,uy]=ulinbc(U,a,b,X,Y)
%
% [u,ux,uy]=ulinbc(U,a,b,X,Y)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function determines a harmonic function
% varying linearly along the sides of a rectangle
% with specified corner values
%
% U     - corner values of the harmonic function
%         [U(1),...U(4)] <=> corner coordinates
%         (0,0), (0,a), (a,b), (0,b)
% a,b   - rectangle dimensions in the x and y
%         directions
% X,Y   - array coordinates where the solution
%         is evaluated
% u     - function values evaluated for X,Y
% ux,uy - first derivative components evauated
%         for the X,Y arrays

c=[1,0,0,0;1,a,0,0;1,a,b,a*b;1,0,b,0;]\U(:);
u=c(1)+c(2)*X+c(3)*Y+c(4)*X.*Y;
ux=c(2)+c(4)*Y; uy=c(3)+c(4)*X;