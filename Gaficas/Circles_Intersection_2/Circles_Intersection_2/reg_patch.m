function hr=reg_patch(R,c,axs);
% draw the pologonal region and its border
%
%   Author:  Alexander Vakulenko
%   e-mail:  dspt@yandex.ru
%   Last modified: 20050123
%
hr=[];     % array of handles for patch object
narg=nargin;
if (narg>3) | (narg<1),
    return;
else
    if nargin==2,
        c='c';
    else
        if nargin==1,
            axs=gca;
            c='c';
        end;
    end;
end;

K=R(1,1);  % Number of components in region R

for m=1:K,
  N=R(1,m+1); % index of begin data for component number m
  M=R(2,m+1); % index of end data for component number m
  % function brush create patch object for drawing one component
  hr=[hr brush(axs,R(:,N:M),c)];
end;

function h=brush(axs,R,c);
% draw one component of region
h=[];
K=R(1,1); % Number of lines in border of this component
% L - is outer border of component (represented as array of xy-coord)
L=R(:,R(1,2):R(2,2));
L=[L L(:,1)];
hL=line(L(1,:),L(2,:),'Parent',axs,'Color','k','linestyle','-','linewidth',2);
for i=2:K,
    % add to patch inner borders of component
    cont=R(:,R(1,i+1):R(2,i+1));
    cont=[cont cont(:,1)];
    L=[L cont L(:,1)];
    hL=[hL line(cont(1,:),cont(2,:),'Parent',axs,'Color','k','linestyle','-','linewidth',2)];
end;
L=[L L(:,1)];
h=[hL patch(L(1,:),L(2,:),c,'Parent',axs,'linestyle','none')];
