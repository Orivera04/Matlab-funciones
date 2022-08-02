function data = getdata( root, var, docode)
%GETDATA Get the modeling data from boundary constraint root node.
%
%  DATA = GETDATA(ROOT) is the data that is valid for the boundary modeling
%  at the given root node.
%  
%  DATA = GETDATA(ROOT,'Response') is an array of double of all data
%  DATA = GETDATA(ROOT,'Local') is a sweep set of local data
%  DATA = GETDATA(ROOT,'Global') is an array of doub;e of global points

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.6.6.1 $    $Date: 2004/02/09 08:13:29 $ 

if nargin < 2 || isempty(var)
    var = 'Response';
end
if nargin < 3,
    docode = true;
end

friend= getfriend(root);

data = root.Data;
if iscell( data ),
    switch lower( var ),
        case 'response',
            if isa( data{end}, 'xregpointer' )
                data = data{end}.sweepset ;
            else
                data = sweepset(data{end});
            end
            data = double(data);
            factnums= 1:size(data,2);
        case 'local',
            friend= get(friend,'local');
            factnums= 1:nfactors(friend);
            data = data{1}.sweepset;
            data= data(:,factnums);
        case 'global',
            factnums= nlfactors(friend)+1:nfactors(friend);
            data = double(data{2}.info);
    end
elseif isa( data, 'xregpointer' ),
    data = data.info;
end
if docode   
    data(:,:) = i_code( friend , double(data), factnums );
end




function X= i_code(m,X,factnums)

if nargin<3
    factnums= 1:nfactors(m);
end

[LB,UB,r] = range(m);
LB=LB(factnums);
UB=UB(factnums);
r=r(factnums);

mid= (LB+UB)/2;
X= double(X);
for i= 1:size(X,2);
    X(:,i)= 2*(X(:,i)-mid(i))./r(i);
end    