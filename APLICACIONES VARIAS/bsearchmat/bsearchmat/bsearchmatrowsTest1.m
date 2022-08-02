clc, clear all
format compact
line='------------------------------------';
mat=[
     0          45        -54
     38        45        -54
     45        -54         38
     -54        38         45
    -54         38         45
     90         40         55
     45        -54         38
     38         45        -54
      ];

% % ROWS OF INPUT DATA MUST BE SORTED BASED ON SUM OF THEIR COLUMN VALUES  
matwithsum=sortrows([sum(mat,2), mat],1); % sum or rows is first column and sort based on column1
mat=matwithsum(:,2:end)                   % removing first column
disp(line);
srow=[45   -54    38] %row to be search in mat
% srow=[45   -54    0]
disp(line);
% % -----------------------------------------
% % case 1:
% % serach indices of all rows in mat that match to srow
str=sprintf('%s','Example call: index1=bsearchmatrows(mat,srow)'); disp(str);
index1=bsearchmatrows(mat,srow)
disp(line);
% % -----------------------------------------
% % case 2:
% % serach index of first row in mat that matches to srow
str=sprintf('%s','Example call: index1=bsearchmatrows(mat,srow,''first'')'); disp(str);
index1=bsearchmatrows(mat,srow,'first')
disp(line);
% % -----------------------------------------
% % case 3:
% % serach index of last row in mat that matches to srow
str=sprintf('%s','Example call: index1=bsearchmatrows(mat,srow,''last'')'); disp(str);
index1=bsearchmatrows(mat,srow,'last')
disp(line);
% % -----------------------------------------
% % case 4:
% % serach indices of all rows in mat that match sum of column values of
% % srow
str=sprintf('%s','Example call: index1=bsearchmatrows(mat,srow,''allcolsum'')'); disp(str);
index1=bsearchmatrows(mat,srow,'allcolsum')
disp(line);
% % -----------------------------------------
% % case 4: (combine case 4 and case 1)
str=sprintf('%s','Example call: [index1,index2]=bsearchmatrows(mat,srow,''colsumandval'')'); disp(str);
[index1,index2]=bsearchmatrows(mat,srow,'colsumandval')


% % This program or any other program(s) supplied with it does not provide any
% % warranty direct or implied.
% % This program is free to use/share for non-commerical purpose only. 
% % Kindly reference the author.
% % Thanking you.
% % @ Copyright M A Khan
% % Email: khan_goodluck@yahoo.com 
% % http://www.m-a-khan.blinkz.com/

