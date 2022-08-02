%%NAME
%%  etabdef - defines a table 
%%
%%SYNOPSIS
%%  [colsXW rowsYH]=etabdef(rows,cols[,x,y[,width,height
%%                          [,colsWidth[,rowsHeight]]])
%%
%%PARAMETER(S)
%%  rows       number of rows
%%  cols       number of columns
%%  x          x-position (sw-corner) of table
%%  y          y-position (sw-corner) of table
%%  width      width of table
%%  height     height of table
%%  colsWidth  vector of relative width of columns ([1 1 1 ... 1]==equal widths)
%%  rowsHeight vector of rel. height of columns ([1 1 1 ... 1]==equal heights)
%%  colsXW     matrix of x-positions and width of columns,
%%             size of matrix is (number of cols) X 2  
%%             examples:  colsXW(5,1) = x-position of colum 5
%%                        colsXW(5,2) = width of colum 5 
%%  rowsYH     matrix of y-positions and heigth of rows,
%%             size of matrix is (number of rows) X 2  
%%             examples:  cellXW(5,1) = y-position of row 5
%%                        cellXW(5,2) = height of row 5 
%% 
%%GLOBAL PARAMETER(S)
%%  eTabBackgroundColor
% written by stefan.mueller@fgan.de (C) 2007

function [colsXW,rowsYH]=etabdef(rows,cols,x,y,width,height,colsWidth,rowsHeight)
  if nargin>8 | nargin<2 | nargin==3 | nargin==5
    eusage('[colsXW rowsYH]=etabdef(rows,cols[,x,y[width,height[,colsWidth[,rowsHeight]]]])');
  end
  eglobpar;
  if nargin<8
    rowsHeight=ones(1,rows);
  end
  if nargin<7
    colsWidth=ones(1,cols);
  end
  if nargin<6
    width=ePlotAreaWidth;
    height=ePlotAreaHeight;
  end
  if nargin<4
    x=ePlotAreaPos(1);
    y=ePlotAreaPos(2);
  end
  
% columns size 
  colsXW=zeros(cols,2); 
  totalSize=sum(colsWidth);
  colsXW(:,2)=width*colsWidth'/totalSize;
  for i=1:cols
    colsXW(i,1)=x+sum(colsXW(1:i-1,2));
  end

% rows size 
  rowsYH=zeros(rows,2); 
  totalSize=sum(rowsHeight);
  rowsYH(:,2)=height*rowsHeight'/totalSize;
  for i=1:rows
    rowsYH(i,1)=y+height-sum(rowsYH(1:i,2));
  end

% background
  if eTabBackgroundColor(1)>=0
    erect(eFile,x*eFac,...
                y*eFac,...
                width*eFac,...
                height*eFac,...
                0,eTabBackgroundColor,0,0);             
  end
