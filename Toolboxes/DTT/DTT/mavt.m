function [ORD,U,w,hnp] = mavt(A,w,varargin)
%MAVT performs the classic multi attribute value theory analysis
%
%   syntax: [ORD,U,w,hnp] = mavt(A,w,varargin)
%
%   INPUT ARGUMENTS
%       - A              m X n Environmental Impact matrix where m are alternatives considered and n the indicators.
%       - w              1 X n vector of weights. To derive interactively this vector, call the function with this parameter
%                        empty, e.g., [ORD,U,w] = mavt(A,[],varargin)
%                        When this parameter is left empty, the user is prompted to fill couple comparison matrix; linked elements
%                        are automatically computed so as to ensure consistency.
%       - varargin       n  L X 2 utility function matrix, where L is the number of points used to define them.
%                        These matrices must be organised column wise: the first column is to contain indicator values, 
%                        while the second one is devoted to utility levels.
%                        To force a persistent utility level, you must enter two or more consecutive 
%                        indicator values for that level.
%                        The n matrices don't necessarily need to be of the same size.
%
%
%   OUPUT ARGUMENTS
%       - ORD            structure containing the following fields:
%                        - alt       1 X m array, where m is the number of the alternatives considered,
%                                    containing the index of the alternatives, which are sorted in
%                                    descending order.
%                        - perf      1 X m array of performances associated to each alternative. 
%       - U              m X n Environmental Impact matrix where each element represents the utility associated to it.
%       - w              1 X n vector of weights     
%       - hnp            1 X 2 array of figure handles.


% Authors:      Francesco di Pierro        Dep. of Electronics and Computer Science (DEI),
%                                          Politecnico di Milano
%                                          f_dipierro@yahoo.com
%
%               Emanuele Betti             Dep. of Electronics and Computer Science (DEI),
%                                          Politecnico di Milano
%                                          lele.betti@secsrl.it

%%%%%%%%%%%%%%% INPUT ARGUMENTS CHECKING %%%%%%%%%%%%

%disp('Input Arguments checking...');

sA = size(A);
if length(varargin)~=sA(2)
    error('You must provide a utility function for each indicator considered');
end
ErrorNo = 0;
syst = [];
for i=1:length(varargin)
    UF = varargin{i};
    if any(UF(:,2)>1|UF(:,2)<0)
        disp(['The utility function associated to the indicator No. ',int2str(i),' exceed limits']);
        ErrorNo = 1;
    end
end
if ErrorNo
    disp('');
    error('The function will be terminated due to utility function miss-specification');
end


%%%%%%%%%%%%%%%%    PLOT UTILITY FUNCTIONS  %%%%%%%%%%%%%%%%%%%%%

np = length(varargin);
npc = round(sqrt(np));
npr = ceil(np/npc);
hnp(1) = figure;
set(hnp(1),'name','Utility Functions','NumberTitle','off');
for i=1:np
    subplot(npr,npc,i),plot(varargin{i}(:,1),varargin{i}(:,2));
    set(gca,'Fontname','Arial Narrow')
    legend(['U(',inputname(i+2),')']);
end
set(hnp(1),'handlevisibility','off');

%%%%%%%%%%%%%%%%  INTERPOLATION OF UTILITY VALUES %%%%%%%%%%%%%%%

%disp('Interpolation of utility values');
U = [];
for i=1:size(A,2)
    UF = varargin{i};
    U(:,i) = interp1(UF(:,1),UF(:,2),A(:,i),'linear','extrap');
end

%%%%%%%%%%%%%%%%%%%% WEIGHTS COMPUTATION %%%%%%%%%%%%%%%%%%%%%%%%

answer = 'enter';
abort = 0;
if ~isempty(w)
    if size(w,1)~=1 | size(w,2)~=size(A,2) | any(w>1) | any(w<0) | any(isnan(w))
        disp(['The weight vector must be a 1 X ',int2str(size(A,2)),' vector of values within the 0-1 range']);
    end
else
    disp('You must fill the compareson matrix one value at the time;');
    disp(' ');
    disp('You can only provide values for the upper triangular matrix;');
    disp(' ');
    disp('Linked elements will be filled by consistency.');
    disp(' ');
    IM = diag(ones(size(A,2),1));
    IM(~IM) = NaN
    disp(' ');
    err = 1;
    while err
        try
            str = input('To set the element i,j to val, type IM(i,j) = val: ','s');
            matrname = strrep(strtok(str,'('),' ','');
            begtoken = strtok(str,')');
            lasttok = strtok(flipdim(begtoken,2),'(');
            I = str2num(flipdim(strrep(lasttok,' ',''),2));
            if I(1)>I(2) | ~isnan(IM(I(1),I(2))) | ~strcmp(matrname,'IM') | ~(all(ismember(I,1:size(A,2))))
                disp('You can only eneter values for no-NaN upper triangular elements of the Matrix IM;');
            else
               eval([str,';']);
               IM = update(IM)
               disp(' ')
               if all(all(~isnan(triu(IM))))
                   break
               end
            end
        catch
            lasterr
            ex = 'enter';
            while ~any(strcmp(ex,{'K','k','A','a'}))
                ex = input('Keep going or abort? (K/A): ','s');
            end
            if any(strcmp(ex,{'A','a'}))
                abort = 1;
                break
            end
        end
    end
end
if abort
    return
end
if isempty(w)
    w = IM(1,:)/sum(IM(1,:));
end
W = repmat(w,size(A,1),1);          

%%%%%%%%%%%%%%%%%%%%%%%%%%%% SORTING PROCEDURE %%%%%%%%%%%%%%%%%%%%%%%%%%%%  
                
UT = sum((U.*W)');
[ORD.perf,ORD.alt] = sort(UT);
ORD.perf = flipdim(ORD.perf,2);
ORD.alt = flipdim(ORD.alt,2);

hnp(2) = plotorder(ORD,mfilename);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   RECURSIVE SUBFUNCTION   %%%%%%%%%%%%%%%%%%%%%

function    IM = update(IM)

[r,c] = find(isnan(triu(IM)));
for i=1:length(r)
    for j=1:length(IM)
        if r(i)<j
            testr = IM(r(i),j);
        elseif r(i)>j
            testr = 1/IM(j,r(i));
        else
            testr = NaN;
        end
        if c(i)>j
            testc = IM(j,c(i));
        elseif c(i)<j
            testc = 1/(IM(c(i),j));
        else
            testc=NaN;
        end
        if all(~isnan([testr,testc]))
            IM(r(i),c(i)) = testr*testc;
            IM = update(IM);
        end
    end
end            
     