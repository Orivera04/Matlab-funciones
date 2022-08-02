function out = errmoth(para);
%ERRMOTH Error function for fitting the moth data.
%	This function is used in fitmoth.m.

%	J.-S. Roger Jang, 1993

global moth;
data_n = length(moth);
out = norm(moth(:,2) - para(1)*moth(:,1).^para(2))/sqrt(data_n);
