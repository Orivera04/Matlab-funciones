function plotfitted(covariate,fitmatrix,labelx,labely)

% PLOTFITTED - produces errorbar plot of many distributions
%
%    PLOTFITTED(COVARIATE,FITMATRIX,LABELX,LABELY) outputs a errorbar plot of a set of
%    distributions, where COVARIATE is the value to be plotted on the x-axis, FITMATRIX
%    is a matrix, where the rows correspond to COVARIATE and the columns contain the
%    low, middle, and high values to be graphed.

%-------------------------------------------------------------  
%  Jim Albert - May 15, 1998
%-------------------------------------------------------------

errorbar(covariate,fitmatrix(:,2),fitmatrix(:,2)-fitmatrix(:,1),fitmatrix(:,3)-fitmatrix(:,2),'o')
xlabel(labelx)
ylabel(labely)


