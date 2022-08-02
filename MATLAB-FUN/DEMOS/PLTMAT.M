function pltmat(a,matrixName,gridColor,fontSize);
%PLTMAT Display a matrix in a figure window.
%	PLTMAT(X,matrixName,gridColor,fontSize) takes
%	the matrix X and displays it using gridColor for the
%	XColor and YColor, fontSize for the FontSize of each
%	matrix element, and matrixName as the title for the 
%	plot. 

%       Ned Gulley, Denise Chen; June 1993.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

% Clear the current axis
cla reset;
[m,n]=size(a);

% Place the text in the correct locations
% Index over number of rows
    for rowCnt=1:m,
        % Index over number of columns
        for colCnt=1:n,
            numberString=num2str(a(rowCnt,colCnt));
            text(colCnt-.5,m-rowCnt+.5,numberString, ...
                 'HorizontalAlignment','center', ...
                 'Color','y', ...
                 'FontWeight','bold', ...
                 'FontSize',fontSize);
        end;
    end;

set(gca,'Box','on', ...
        'Visible','on', ...
        'xLim',[0 n], ...
        'xGrid','on', ...
        'xTickLabels',[], ...
        'xTick',0:n, ...
        'yGrid','on', ...
        'yLim',[0 m], ...
        'yTickLabels',[], ...
        'yTick',0:m, ...
        'Aspect',[1, NaN], ... 
        'GridLineStyle',':', ...
        'LineWidth',3, ...
        'XColor',gridColor, ...
        'YColor',gridColor);

title(matrixName);
