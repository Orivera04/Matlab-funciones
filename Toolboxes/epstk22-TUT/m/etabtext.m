%%NAME
%%  etabtext - fill cell of table with text
%%
%%SYNOPSIS
%%  etabtext(colsXW,rowsYH,row,col,text[,alignment
%%           [,font[,fontSize[,color[,bgColor]]]])
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
%%  row        number of row
%%  col        number of column
%%  text       text of cell
%%  alignment  1=right 0=center -1=left
%%  font       font number (definition in einit.m)
%%  fontSize   relative fontsize in percent (100=default) 
%%  color      color of text
%%  bgColor    color of background, [r g b] vector, if r<0 then transparent
%% 
%%GLOBAL PARAMETER(S)
%% eTextColor
%% eTextFont
% written by stefan.mueller@fgan.de (C) 2007

function etabtext(colsXW,rowsYH,row,col,text,alignment,font,fontSize,color,bgColor)
  if nargin<5 | nargin>10
    eusage('etabtext(colsXW,rowsYH,row,col,text[,alignment[,font[,fontSize[,color[,bgColor]]]])');
  end
  eglobpar;
  if nargin<10
    bgColor=[-1 0 0];
  end
  if nargin<9
    color=eTextColor;
  end
  if nargin<8
    fontSize=100;
  end
  if nargin<7
    font=eTextFont;
  end
  if nargin<6
    alignment=0;
  end
  relTextDistance=0.25; 

% background
  if bgColor(1)>=0
    erect(eFile,colsXW(col,1)*eFac,...
                rowsYH(row,1)*eFac,...
                colsXW(col,2)*eFac,...
                rowsYH(row,2)*eFac,...
                0,bgColor,-1,0);
  end
% fontsize  
  minCellHeight=min(rowsYH(:,2));
  fontSize=minCellHeight*(1-relTextDistance)*fontSize/100;
  textDistance=minCellHeight*relTextDistance;
% x,y
  if alignment==1
    x=colsXW(col,1)+textDistance;
    y=rowsYH(row,1)+textDistance;
  elseif alignment==0
    x=colsXW(col,1)+colsXW(col,2)/2;
    y=rowsYH(row,1)+textDistance;
  else
    x=colsXW(col,1)+colsXW(col,2)-textDistance;
    y=rowsYH(row,1)+textDistance;
  end
  etext(text,x,y,fontSize,alignment,font,0,color);
