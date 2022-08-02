% % Binary Serach of rows of M-by-N Matrix
% % Search is based on sum of column values of rows of input M-by-N Matrix
% % i.e. Rows of input Matrix must already be sorted in ascending order
% % based on sum of their column values. i.e.
% %  row1sum<row2sum<...rowjsum<...rowmsum
% % where rowjsum=sum(mat(j,:),2) (i.e sum of column values)

% % If mat is not sorted use following two statments to sort rows of mat 
% % according to sum of column values
% % matwithsum=sortrows([sum(mat,2), mat],1); 
% % mat=matwithsum(:,2:end); 

% % INPUT:
% % mat: Matrix contains values such as
% %      [x1, y1,..., zn;
% %      x2, y2,..., zn;
% %      ...           
% %      xm, ym,..., zn];

% % srow: row that is to be searched in mat

% % OUTPUT:
% % Using following different value of parameter 'type' following output can be return
% % 1. 'first':  returns 'indvec1' i.e index of first occured row in mat
% %              that matches to srow. 
% % 2. 'all':    returns 'indvec1' i.e indices of all rows in mat that matches to srow.
% % 3. 'last':   returns 'indvec1' i.e index of last row in mat that matches to srow.
% % 4. 'allcolsum': returns 'indvec1' i.e indices of all k rows of mat such that
% %                 sum(mat(j,:),2)=sum(srow,2), where 1<=j<=k
% % 5. 'colsumandval': return two index vector first is similar to return by "allcolsum" and second
% %                    is similiar to return by "all' option.


% % Note that if we are searching e.g. [5 4 2] by option 'first' then there may be many rows 
% % whose column sum is equal to given row e.g.  [2 4 5],[0 0 11],[4 2 5], [5 4 2] but only
% % last row i.e. [5,4,2] matches in all columns to given row to be searched.


function [indvec1,indvec2] = bsearchmatrows(mat,srow,varargin)

% % % Default Values 
type='all';
defaultValues = {type};
% % % Assign Values 
nonemptyIdx = ~cellfun('isempty',varargin);
defaultValues(nonemptyIdx) = varargin(nonemptyIdx);
[type] = deal(defaultValues{:});
% % %  ------------------

% % convert to double for processing, otherwise sum of column result may be
% % incorrect
mat=double(mat);   
srow=double(srow);

indvec1=[];
indvec2=[]; 
if (~strcmpi(type,'all') & ~strcmpi(type,'first') & ~strcmpi(type,'last')&...
        ~strcmpi(type,'last')& ~strcmpi(type,'allcolsum') & ~strcmpi(type,'colsumandval') )   
    disp('incorrect value of type parameter');    
    return
end

sumandvaleqVec=[]; %vector to hold indices where all column matches
srowsum=sum(srow,2); % sum of column values of srow
from=1;
to=size(mat,1); % number of rows in mat
found=0;
while (from<=to)
    mid = round((from + to)/2);    
    diff = (sum(mat(mid,:),2))-srowsum;
    if (diff==0)
        found=1; % found row of equal sum i.e. sum(mat(mid,:),2)=sum(srow,2)
        
       % now we would do forward & backward searching range of  
       % all rows with sum of columns values equal to srowsum
       [rStart,rEnd]=findindofeqcolsumrows(mat,mid);
      
        % For indices range "rStart" to "rEnd" sum of column is equal to srowsum.
        % But rows with sum of columns equal to srowsum can have different values 
        % for its columns than srow.
        % Now we would check all values of columns of mat in the range
        % "rStart" to "rEnd", are they equal to columns of srow?
        civec=0;        
        for r=rStart:rEnd
            if( isequal(mat(r,:),srow) ) %all columns match
                civec=civec+1;
                sumandvaleqVec(civec)=r;
            end
        end        
        break; % break from outer while loop 
        
    elseif (diff<0)   % ||a(mid)|| < ||srow|| 
        from=mid+1;
    else              % ||a(mid)||  > ||srow||  
        to=mid-1;			
    end
end

% % % Not Found
if(~found)    
    return;
end

% % % Handling various values of parameter 'type'
if (strcmpi(type,'all'))    
    indvec1=sumandvaleqVec;       
elseif (strcmpi(type,'first'))
    if(length(sumandvaleqVec)~=0)
        indvec1=sumandvaleqVec(1);               
    end    
elseif (strcmpi(type,'last'))
    if(length(sumandvaleqVec)~=0)
        indvec1=sumandvaleqVec(end);               
    end    
elseif (strcmpi(type,'allcolsum'))
    indvec1=[rStart:rEnd];       
elseif (strcmpi(type,'colsumandval'))
    indvec1=[rStart:rEnd];        
    indvec2=sumandvaleqVec;
end


% % This program or any other program(s) supplied with it does not provide any
% % warranty direct or implied.
% % This program is free to use/share for non-commerical purpose only. 
% % Kindly reference the author.
% % Thanking you.
% % @ Copyright M A Khan
% % Email: khan_goodluck@yahoo.com 
% % http://www.m-a-khan.blinkz.com/


