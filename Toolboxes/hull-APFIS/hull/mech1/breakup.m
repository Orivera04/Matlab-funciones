function [xmag,ymag,xcor,ycor]=breakup(vectors)
%BREAKUP Breaks a standard form force vector into its component parts.
%   [XMAG,YMAG,XCOR,YCOR]=BREAKUP(X) Subroutine that breaks a 
%   multivector load matrix, X, into four column vectors representing the
%   x magnitudes, y magnitudes, x coordinates, and y coordinates.
%    
%   This function is designed as a routine to be called from other
%   functions.
xmag=vectors(:,1);
ymag=vectors(:,2);
xcor=vectors(:,3);
ycor=vectors(:,4);
