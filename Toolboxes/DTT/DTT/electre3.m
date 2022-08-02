function [ORD, hnp] = electre3 (A,q,p,v,w,s1,s2)
%ELECTRE3 performs the multi attribute analysis according to the ELECTRE III method
%
%   Syntax: [ORD, hnp] = electre3 (A,q,p,v,w,s1,s2)
%
%   INPUT ARGUMENTS
%       - A         n X m Environmental Impact matrix where m are alternatives considered and n the indicators.
%       - q         n X 1 "indifference threshold vector"
%       - p         n X 1 "strict preference vector"
%       - v         n X 1 "veto vector"
%       - w         n X 1 weights vector
%       - s1,s2     parameters of the discrimination threshold (slamb), according to the following expression:
%
%                       slamb = s1 +lamb*s2
%
%                   where lamb is a value depending on the "MATRICE DI CREDIBILITA' DEI SURCLASSAMENTI".
%
%   OUTPUT ARGUMENTS
%       - ORD       n X n array. The ith row contains information about the ith alternative. A 1 in the position i,j
%                   means that the ith alternative out competes the jth one; NaN otherwise.
%       - hnp       handle to the figure created

% Author:       Francesco di Pierro        Dep. of Electronics and Computer Science (DEI),
%                                          Politecnico di Milano
%                                          f_dipierro@yahoo.com



%%%%%%%%%%%%%%%%   INPUT ARGUMENTS CHECKING   %%%%%%%%%%%%%%%%

error(nargchk(7,7,nargin));

if size(A,1)~=size(q,1) | size(A,1)~=size(p,1) | size(A,1)~=size(v,1) | size(A,1)~=size(w,1)
    error(['Size(vec,2) must be equal to size(',inputname(1),'2) where vec represents vectors ',inputname(2),',',inputname(3),',',inputname(4),',',inputname(5),' !!!']);
end
if any(isnan(A(:))) | any(isnan(q)) | any(isnan(p)) | any(isnan(v)) | any(isnan(w)) | any(isnan(s1)) | any(isnan(s2))
    error('NaN detected: NaNs are not allowed within this routine!');
end
if prod([size(s1),size(s2)])~=1
    error([inputname(6),' and ',inputname(7),' must be scalar numeric valid values!']);
end

%%%%%%%%%%%%%%%%    EVALUATE AGREEMENT-DESAGREEMENT MATRICES   %%%%%%%%%%%%%

%initialize agreement-disagreement matrices
C = zeros(size(A,2),size(A,2),size(A,1));
D = zeros(size(A,2),size(A,2),size(A,1));
for ind=1:size(A,1)                                 %for every indicator
    %initialize the performance matrix
    perf = [];
    for i=1:size(A,2)
        for j=1:size(A,2)
            perf(i,j) = A(ind,j)-A(ind,i);
            if perf(i,j) < q(ind)
                C(i,j,ind) = 1;               
            elseif perf(i,j) > p(ind)
                C(i,j,ind) = 0;
            else
                C(i,j,ind) = 1-(q(ind)-perf(i,j))/(q(ind)-p(ind));
            end
            if perf(i,j) < p(ind)
                D(i,j,ind) = 0;
            elseif perf(i,j) > v(ind)
                D(i,j,ind) = 1;
            else
                D(i,j,ind) = (perf(i,j)-p(ind))/(v(ind)-p(ind));
            end
        end
    end
end
W = shiftdim(repmat(w,[1,size(A,2),size(A,2)]),1);
CW = sum(C.*W,3)./100;
DW = sum(D.*W,3)./100;

%%%%%%%%%%%%%%%%%%%  "MATRICE DI CREDIBILITA' DEI SURCLASSAMENTI"   %%%%%%%%%%%%%%%%%%%%%%

CS = [];
for i=1:size(A,2)
    for j=1:size(A,2)
        if i==j
            CS(i,j) = NaN;
            continue
        end
        CS(i,j) = CW(i,j);
        for k=1:size(A,1)
            if D(i,j,k) > CW(i,j)
                CS(i,j) = CS(i,j)*(1-D(i,j,k))/(1-CW(i,j));
            end
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%    DESCENDING ORDER    %%%%%%%%%%%%%%%%%%%%

TMP = CS;
OD = NaN*ones(size(A,2));                
for i=1:size(A,2)
    [worst,TMP] = calc_Alpha(TMP,'dis',s1,s2);
    OD(i,:) = [worst', NaN*(1:length(A)-length(worst))];
    if all(isnan(TMP))
        alt_no = 1:length(TMP);
        miss_alt_dis = setdiff(alt_no,OD(~isnan(OD(:))));
        if ~isempty(miss_alt_dis)
            OD(i+1,:) = [miss_alt_dis,NaN*(1:length(A)-length(miss_alt_dis))];
        end
        break
    end
end  


%%%%%%%%%%%%%%%%%%%%%%%%%%%%    ASCENDING ORDER    %%%%%%%%%%%%%%%%%%%%

TMP = CS;
OA = NaN*ones(size(A,2));                
for i=1:size(A,2)
    [best,TMP] = calc_Alpha(TMP,'asc',s1,s2);
    OA(i,:) = [best', NaN*(1:length(A)-length(best))];
    if all(isnan(TMP))
        alt_no = 1:length(TMP);
        miss_alt_as = setdiff(alt_no,OA(~isnan(OA(:))));
        if ~isempty(miss_alt_as)
            OA(i+1,:) = [miss_alt_as,NaN*(1:length(A)-length(miss_alt_as))];
        end
        break
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%    FINAL ORDER    %%%%%%%%%%%%%%%%%%%

OA = flipdim(OA,1); 
MREL = 0*ones(size(A,2));
for i=1:size(A,2)
    [rOD,cOD] = find(OD==i);
    saOD = OD(rOD+1:end,:);
    saOD = saOD(find(~isnan(saOD(:))));
    spOD = OD(1:rOD-1,:);
    spOD = spOD(find(~isnan(spOD(:))));
    nsOD = OD(rOD,:);
    nsOD = nsOD(find(~isnan(nsOD(:)) & nsOD(:)~=i));
    [rOA,cOA] = find(OA==i);
    saOA = OA(rOA+1:end,:);
    saOA = saOA(find(~isnan(saOA(:))));
    spOA = OA(1:rOA-1,:);
    spOA = spOA(find(~isnan(spOA(:))));
    nsOA = OA(rOA,:);
    nsOA = nsOA(find(~isnan(nsOA(:)) & nsOA(:)~=i));
    sur_att = union(intersect(saOD,saOA),union(intersect(nsOD,saOA),intersect(saOD,nsOA)));
    sur_pas = union(intersect(spOD,spOA),union(intersect(nsOD,spOA),intersect(spOD,nsOA)));
    MREL(i,sur_att) = 1;
    MREL(i,sur_pas) = -1;
end
LN = NaN*ones(size(A,2),size(A,2)+1);
MTOP = NaN*ones(size(A,2));
altbeg = find(max(MREL')==0);
ALL = 1:size(A,2);
ln = find(MREL(altbeg(1),:)==0);
LN(1:length(ln),1) = ln';
for i=1:length(ln)
    LN(i,3:2+length(find(MREL(ln(i),:)==-1))) = find(MREL(ln(i),:)==-1);
    LN(i,2) = length(find(MREL(ln(i),:)==-1));
end
ALLTMP = setdiff(ALL,LN(:,1));

ORD = calcord(MTOP,MREL,ALL,ALLTMP,LN);

for i=1:length(ORD)
    remc = find(ORD(i,:)==1);
    for j=1:length(remc)
        rm = intersect(remc,find(ORD(remc(j),:)==1));
        if any(rm)
            ORD(i,rm) = NaN;
        end
        if all(isnan(ORD(i,remc+1:end)))
            break
        end
    end
end
        

hnp = plotorder(ORD,mfilename);

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%     SUBFUNCTION    %%%%%%%%%%%%%%%%%%%%%%%%%    

% Recursive subfunction to compute ascending and descending ordering vectors

function  [worst, TMP] = calc_Alpha(TMP,ord,s1,s2,it)

global LAMBDA_IT

if strcmp(ord,'asc')
    method = 'min';
else
    method = 'max';
end
if nargin == 4
    LAMBDA_IT = 0;
    lamb = max(max(TMP)); slamb = s1+lamb*s2; 
    treshold = lamb-slamb;
else
    lamb_vec = flipdim(sort(TMP(:)),1);
    lamb_vec(isnan(lamb_vec)) = [];
    lamb = lamb_vec(it+1);
    slamb = s1+lamb*s2;
    treshold = lamb-slamb;
end
Alpha = zeros(length(TMP),1); 
[row,col] = find(TMP>treshold);
survec = [];
for i=1:length(row)
    if TMP(row(i),col(i))-TMP(col(i),row(i))>slamb
        survec(i) = 1;
    else
        survec(i) = 0;
    end
end
if strcmp(ord,'dis')
    testvec = unique(row);
else
    testvec = unique(col);
end
for i=1:length(testvec)
    if ~isempty(find(row==testvec(i)))
        Alpha(testvec(i)) = sum(survec(find(row==testvec(i))));
    end
    if ~isempty(find(col==testvec(i)))
        Alpha(testvec(i)) = Alpha(testvec(i))-sum(survec(find(col==testvec(i))));
    end
end
altdel = find(all(isnan(TMP')).*all(isnan(TMP)));
if ~isempty(altdel)
    Alpha(altdel) = NaN;
end
val = feval(method,Alpha);
worst = find(Alpha==val);
switch length(worst)
case 1
    TMP(worst,:) = NaN;
    TMP(:,worst) = NaN;
case length(find(~isnan(Alpha)))
    if lamb==min(min(TMP))
        TMP(worst,:) = NaN;
        TMP(:,worst) = NaN;
    else
        if isempty(LAMBDA_IT)   LAMBDA_IT = 1;  else LAMBDA_IT = LAMBDA_IT+1; end
        it = LAMBDA_IT;
        [worst, TMP] = calc_Alpha(TMP,ord,s1,s2,it);
    end
otherwise
    TMP_it = TMP;
    ind = 1:size(TMP,1);
    ind(worst) = [];
    TMP_it(ind,:) = NaN;
    TMP_it(:,ind) = NaN;
    [worst, TMP_intermediate] = calc_Alpha(TMP_it,ord,s1,s2);
    TMP(worst,:) = NaN;
    TMP(:,worst) = NaN;
end
ST = dbstack;
%if the level of recursion is 1, that is this is the last time that the next lines are executed... 
if size(ST,1)==1
    %clear the global variable
    clear global LAMBDA_IT;
%otherwise...
else
    %clear the global variable link
    clear LAMBDA_IT;
end