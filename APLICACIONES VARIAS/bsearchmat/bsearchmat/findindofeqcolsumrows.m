% % Important Note:
% % Rows of input Matrix must already be sorted in ascending order based on sum of their
% % column values. i.e.
% %  row1sum<row2sum<...rowjsum<...rowmsum
% % where rowjsum=sum(Mat(j,:),2) (i.e sum of column values)

% % Input:
% % Mat: Matrix contains values such as
% %      [x1, y1,..., zn;
% %      x2, y2,..., zn;
% %      ...           
% %      xm, ym,..., zn];

% % Finds indices range [rStart..rEnd] of rows of whose sum of columns is
% % equal to row at the given index 'pos' in the given Matrix 'Mat'.
% % Search begins from index 'pos'. The algorithm serach forward and backward 
% % from index 'pos' until rows of equal column sum to that of Mat(pos,:) are found.
% % For any prceeding or following row where sum in not equal the algorithm stops
% % immediatley as it assumes rows of Mat are sorted based on sum of
% % columns so no need to search further.

% % 'err' is the round-off error margin.  If 'err'
% % value is not passed then default value would be used

function [rStart,rEnd]=findindofeqcolsumrows(Mat,pos)

rStart=[];  
rEnd=[];    

if(pos<=0 || pos>size(Mat,1) )
    disp('invalid postion');
    return
end

startPos=pos;
srow=Mat(startPos,:);  % key row
sumofsrow=sum(srow,2); % sum of 'srow' at index 'pos'

% % backward search
pos=startPos;      % set current position
rStart=startPos;   
while(pos~=1)
    pos=pos-1;
    diff = (sum(Mat(pos,:),2))-sumofsrow; 
    if (diff~=0)
        break;
    end 
    rStart=rStart-1;
end

% % forward search
pos=startPos;    % again reset current position
rEnd=startPos;
while(pos~=size(Mat,1))
    pos=pos+1;
    diff = (sum(Mat(pos,:),2))-sumofsrow; 
    if (diff~=0)
        break;
    end 
    rEnd=rEnd+1;
end


