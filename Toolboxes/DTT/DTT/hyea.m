function [ORD,PERFPAR,W,hnp] = hyea (hy, scale)
%HYEA performs the hierarchical analysis
%
%   Syntax: [ORD,PERFPAR,W,hnp] = hyea (hy, scale)
%
%       INPUT ARGUMENTS
%           - hy        1 X n cell array; n is the number of levels in the hyerarchy, without
%                       considering the super criterion.
%                       The ith cell of the array contains a structure. The structure of
%                       the ith cell contains the following fields:
%
%                       - el        scalar representing the number of elements of the ith level;
%
%                       - cc        m X m X k upper triangular array where m is the number of elements of
%                                   the ith level and k the number of elements of the ith+1
%                                   level. The submatrix (:,:,K), where 0<K<k, is the 
%                                   comparison matrix of the m elements belonging to the ith
%                                   level, according to the K element of the ith+1 level.
%                                   Diagonal elements must be set to ones and lower triangular elements must be set to 'NaN'.
%                                   If the M element of the ith level is not linked to the K element of the upper level,
%                                   it must be that hy{i}.cc(M,:,K) = NaN and hy{i}.cc(:,M,K)= NaN 
%                                   Each element represents the class number of the evaluation 
%                                   
%           - scale     Optional C X 2 array where C is the number of classes of the scaling criterion;
%                       the first column contains the class indices and the second column the respective values.
%                       If no scale is provided, the default Saaty is assumed.
%
%                       Standard Saaty scale:					
%					
%                       Class	Preference				    Val
%                       1	    1/ Fortissima			    1/9
%                       2	    1/( Forte/Fortissima)       1/8
%                       3	    1/Forte			            1/7
%                       4	    1/( Significativa/Forte) 	1/6
%                       5	    1/Significativa			    1/5
%                       6	    1/(Debole/Significativa) 	1/4
%                       7	    1/Debole			        1/3
%                       8	    1/(Uguale/Debole)		    1/2
%                       9	    Uguale			            1
%                       10	    Uguale/Debole			    2
%                       11	    Debole			            3
%                       12	    Debole/Significativa        4
%                       13	    Significativa			    5
%                       14      Significativa/Forte 	    6
%                       16	    Forte/Fortissima		    8
%                       17	    Fortissima			        9
%
%
%
%       OUTPUT ARGUMENTS
%           - ORD       structure containing the following fields:
%                       - alt       1 X A array, where A is the number of the alternatives considered,
%                                   containing the index of the alternatives, which are sorted in
%                                   descending order.
%                       - perf      1 X A array of performances associated to each alternative. 
%           - PERFPAR   1 X n structure array; n is the number of levels in the hierarchy, without
%                       considering the alternatives level. PERFPAR{1} contains information about
%                       the first level with indicators, while PERFPAR{end} contains information about
%                       the super criterion level. The structure contains the following fields:
%                       - alt       A X k array of alternative indices, where A is the number of alternatives
%                                   and K is the number of elements of the level considered.
%                                   For instance, PERFPAR{j}.alt(:,k) is the order of the alternatives
%                                   up to the element k of the level j.
%                                   The alternatives are sorted in descending order.
%                       - perf      A X k array of partial performances associated to the alternatives.
%                                   For instance, PERFPAR{j}.perf(:,k) contains the performances associated
%                                   to PERFPAR{j}.alt(:,k).
%           - W         1 X n cell array; n is the number of levels in the hierarchy, without
%                       considering the supercriterion. W{1} contains information about
%                       the first level with indicators, while W{end} contains information about
%                       the super criterion level. Each element of the cell array is a 1 X k
%                       structure array, where k is the number of elements of the nth level, with
%                       the following field:
%                       - ord       h X 1 array, where h is the number of elements of the level below
%                                   the one being considered, containing the order vector of these 
%                                   elements compared through the element considered of the current level.
%                                   For distance, W{1}(2).ord, contains the order vector of the alternatives
%                                   with respect to the 2nd indicator of the first level.
%            - hnp      handle to the figure created.
%
%       The hierarchical structure is thought to be sorted with the Super criterion at the top and
%       the alternatives at the bottom. The way elements belonging to the same level are distinguished
%       form each other is according to their position moving from left to right. For instance, the first
%       alternative is the bottom left one and the second last element of the 3thd level is the second
%       right most.
%       The cell array hy containing information on each level is organized from the bottom to the
%       top of the hyerarchy. For instance, the first element contains information about the alternatives,
%       while the last one, refers to the top level, without considering the super criterion.
%
%       REMARKS:    - An hierarchy must be complete at the first and last levels; that is all the 
%                   alternatives must be comparable through the indicators of the first level and all
%                   the indicators of the last level must be comparable through the super criterion.

% Author:       Francesco di Pierro        Dep. of Electronics and Computer Science (DEI),
%                                          Politecnico di Milano
%                                          f_dipierro@yahoo.com



%%%%%%%%%%%%%%%%%%%   SETTING DEFAULTS ARGUMENTS & INPUT ARGUMENTS CHECKING %%%%%%%%%%%%%%%%%%%%%%%%%%%

Err1 = 0; Err2 = 1; Err3 = 1; Err4 = 1; Err5 = 1; Err6 = 1; Err7 = 1;

if nargin==1
    scale = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17;...
             1/9,1/8,1/7,1/6,1/5,1/4,1/3,1/2,1,2,3,4,5,6,7,8,9]';
elseif ~isnumeric(scale) | ~isreal(scale) | ~all(ismember(1:size(scale,1)),scale(:,1)) | any(isnan(scale(:,2)))
    disp(['Invalid scale provided: class indeces must be a vector of consecutive integers 1:size(',inputname(2),'1),']);
    disp('and values must be real numbers!');
    Err6 = 0;
end

for i=1:length(hy)
    if ~Err1
        for j=1:length(hy)
            if ~isstruct(hy{i})
                disp([inputname(1),'{',int2str(j),'} is not a structure']);
                Err2 = 0;
                Err3 = 0;
                Err4 = 0;
            else
                Err1 = 1;
            end
        end
    end
    if Err2
        try
            if ~all(strcmp({'el';'cc'},fieldnames(hy{i}))) & ~all(strcmp({'cc';'el'},fieldnames(hy{i})))
                disp(['Structure ',inputname(1),'{',int2str(i),'} has wrong field names']);
                Err3 = 0;
                Err4 = 0;
            end
        catch
            disp(['Structure ',inputname(1),'{',int2str(i),'} has wrong wrong number of fields']);
            Err3 = 0;
            Err4 = 0;
        end
    end
    if Err3 
        if i~=length(hy)
            if size(hy{i}.cc,1)~=hy{i}.el | size(hy{i}.cc,2)~=hy{i}.el | size(hy{i}.cc,3)~=hy{i+1}.el
                disp(['Wrong size of the comparison matrix ',inputname(1),'{',int2str(i),'}.cc']);
                Err4 = 0;
            end   
        else
            if size(hy{i}.cc,1)~=hy{i}.el | size(hy{i}.cc,2)~=hy{i}.el | size(hy{i}.cc,3)~=1
                disp(['Wrong size of the comparison matrix ',inputname(1),'{',int2str(i),'}.cc']);
                Err4 = 0;
            end
        end
    end
    if Err4
        for k=1:size(hy{i}.cc,3)
            Err5(i+k) = 1;
            if ~isnumeric(hy{i}.cc(:,:,k)) | ~isreal(hy{i}.cc(:,:,k))
                disp(['The matrix ',inputname(1),'{',int2str(i),'}cc(:,:,',int2str(k),') is not a matrix of real elements!']);
                Err5(i+k) = 0;
            end
            if any(any(isnan(hy{i}.cc(:,:,k))))
                cons_el = find(prod(isnan(hy{i}.cc(:,:,k))).*prod(isnan(hy{i}.cc(:,:,k)')));    
                if ~isempty(cons_el) & (i==1 | i==length(hy))
                    dspmsg = sprintf(['The hyerarchy can not be incomplete at the first or last level: \n',...
                            '\tthat is all the alternatives must be comparable through all the indicators \n',...
                            '\tof the first level and all the indicators of the last level must be comparable\n',...
                            '\tthrough the supercriterion.']);
                    disp(dspmsg);
                    Err5(i+k) = 0;
                elseif isempty(cons_el)
                    disp(['Warning: uncoupled NaN detected in matrix ',inputname(1),'{',int2str(i),'}.cc(:,:,',int2str(k),').']);
                    Err5(i+k) = 0;
                elseif length(cons_el)==length(hy{i}.cc(:,:,k))
                    disp(['Warning: matrix ',inputname(1),'{',int2str(i),'}.cc(:,:,',int2str(k),') has all NaN. Nodes can''t be disconnected']);
                    Err5(i+k) = 0;
                end
            end
            if Err5(i+k) & Err6
                for M=1:length(hy{i}.cc(:,:,k))
                    for N=1:length(hy{i}.cc(:,:,k))
                        ind = intersect(hy{i}.cc(M,N,k),scale(:,1));
                        if ~isempty(ind)
                            hy{i}.cc(M,N,k) = scale(ind,2);
                        elseif ~isnan(hy{i}.cc(M,N,k))
                            disp(['Element ',inputname(1),'{',int2str(i),'}.cc(',int2str(M),',',int2str(N),',',int2str(k),') is not a valid scale class index!']);
                            Err7 = 0;
                        end
                    end
                end
                if prod(diag(hy{i}.cc(:,:,k)))~=1 & ~isnan(prod(diag(hy{i}.cc(:,:,k))))
                    disp(['Diagonal elements of the matrix ',inputname(1),'{',int2str(i),'}.cc(:,:,',int2str(k),') are not all ones']);
                    Err7 = 0;
                end
            end
        end
    end
end
if ~Err1 | ~Err2 | ~Err3 | ~Err4 | ~all(Err5) | ~Err6 | ~Err7
    error('Something went wrong... the process will be aborted.');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    COMPUTE RANKING FOR ELEMENTS  %%%%%%%%%%%%%%%%%%%%%%%%%

W = [];
for i=1:length(hy)
    w = struct('ord',[]);
    for j=1:size(hy{i}.cc,3)
        tmp = hy{i}.cc(:,:,j);
        del = find(prod(+isnan(tmp)).*prod(+isnan(tmp'))); 
        w(j).ord = NaN*(1:length(tmp))';
        if ~isempty(del)
            map_bf = 1:(hy{i}.el);
            map_aft = map_bf;
            map_aft(del) = []; 
            tmp(:,del) = [];
            tmp(del,:) = [];
        end 
        constestmatind = rand(size(tmp));
        constestmat = NaN*ones(size(tmp));
        for k=1:length(constestmatind(:))
            constestmat(k) = scale(1+round(16*constestmatind(k)),2);
        end
        if rank(tmp)==1
            wh = tmp(:,1)./sum(tmp(:,1));
        else
            [V,D] = eig(tmp);
            wh = V(:,find(diag(D)==max(diag(D))));
            wh = wh/sum(wh);
        end
        if prod(size(tmp))==1
            Conserr = 0;
        else
            Conserrmax = (max(eig(constestmat))- length(tmp))/(length(tmp)-1);
            Conserr = (max(eig(tmp))- length(tmp))/(length(tmp)-1);
            if Conserr/Conserrmax>.1
                disp(' ');
                disp(['Warning: consistency error ratio >.1 for the compareson matrix ',inputname(1),'{',int2str(i),'}.cc(:,:,',int2str(j),').']);
            end
        end
        if ~isempty(del)
            w(j).ord(map_aft) = wh;
        else
            w(j).ord = wh;
        end
    end
    W{i} = w;
end

%%%%%%%%%%%%%  COMPUTE PERFORMANCES OF ALL ADMISSIBLE PATHS FOR EACH ALTERNATIVE  %%%%%%%%%

ord = struct('perf',[]);
for i=1:hy{1}.el
    for j=2:length(W)
        for k=1:length(W{j})
            if j==2
                for z=1:length(W{j-1})
                    perf{k}{z} = W{j}(k).ord(z).*W{1}(z).ord(i);
                    if i==1 & k==1
                        perfpar{j-1}(:,z) = W{1}(z).ord;
                    end
                end
            else
                for z=1:length(W{j-1})
                    perfmat = cell2mat(perf{z});
                    perf{k}{z} = W{j}(k).ord(z).*perfmat;
                end
            end
            temp1 = (cell2mat(perf{k}));
            temp1(find(isnan(temp1))) = [];
            perfpar{j}(i,k) = sum(temp1);
        end
    end    
    temp2 = cell2mat(perf{1});
    temp2(find(isnan(temp2))) = [];
    ord(i).perf = sum(temp2);
    clear perf;
end
for T=1:length(perfpar)
    [PERFPAR{T}.perf,PERFPAR{T}.alt] = sort(perfpar{T});
    PERFPAR{T}.perf = flipdim(PERFPAR{T}.perf,1);
    PERFPAR{T}.alt = flipdim(PERFPAR{T}.alt,1);
end
ordsort = cell(length(ord),1);
[ordsort{:}] = deal(ord.perf);
[ORD.perf,ORD.alt] = sort(cell2mat(ordsort));
ORD.alt = flipdim(ORD.alt,1);
ORD.perf = flipdim(ORD.perf,1);

hnp = plotorder(ORD,PERFPAR,W,mfilename);