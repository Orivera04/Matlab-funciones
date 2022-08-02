%%NAME
%%  etabgrid - draw lines of table
%%
%%SYNOPSIS
%%  etabgrid(colsXW,rowsYH)
%%
%%PARAMETER(S)
%%  colsXW     matrix of x-positions and width of columns,
%%             size of matrix is (number of cols) X 2  
%%             examples:  cellXW(5,1) = x-position of colum 5
%%                        cellXW(5,2) = width of colum 5 
%%  rowsYH     matrix of y-positions and heigth of rows,
%%             size of matrix is (number of rows) X 2  
%%             examples:  cellXW(5,1) = y-position of row 5
%%                        cellXW(5,2) = height of row 5 
%% 
%%GLOBAL PARAMETER(S)
% written by Stefan Mueller stefan.mueller@fgan.de (C) 2003

function etabgrid(colsXW,rowsYH)
  if nargin~=2
    eusage('etabgrid(colsXW,rowsYH)');
  end
  eglobpar;
  cols=size(colsXW,1);
  rows=size(rowsYH,1);
  width=sum(colsXW(:,2));
  height=sum(rowsYH(:,2));
  x=colsXW(1,1);
  y=rowsYH(rows,1);

% xLines
  if eTabXLineVisible 
    xLineY=rowsYH(1:rows-1,1)';
    xLineY=[xLineY;xLineY];
    xLineY=reshape(xLineY,1,2*(rows-1));
    xLineX=[ones(1,rows-1)*colsXW(1,1);
            ones(1,rows-1)*(colsXW(cols,1)+colsXW(cols,2))];
    xLineX=reshape(xLineX,1,2*(rows-1));
    exyline(eFile,0,0,...
                  xLineX*eFac,...
                  xLineY*eFac,...
                  eTabXLineColor,...
                  eTabXLineDash*eFac,...
                  eTabXLineWidth*eFac);
  end
% yLines
  if eTabXLineVisible 
    xLineX=colsXW(2:cols,1)';
    xLineX=[xLineX;xLineX];
    xLineX=reshape(xLineX,1,2*(cols-1));
    xLineY=[ones(1,cols-1)*(rowsYH(1,1)+rowsYH(1,2));
            ones(1,cols-1)*rowsYH(rows,1)];
    xLineY=reshape(xLineY,1,2*(cols-1));
    exyline(eFile,0,0,...
                  xLineX*eFac,...
                  xLineY*eFac,...
                  eTabXLineColor,...
                  eTabXLineDash*eFac,...
                  eTabXLineWidth*eFac);
  end
% frame
  if eTabFrameVisible
    erect(eFile,x*eFac,...
                y*eFac,...
                width*eFac,...
                height*eFac,...
                eTabFrameLineWidth*eFac,...
                eTabFrameColor,0,0);             
  end  
