function [h1, h2, h3]=zplane(z,p);
%ZPLANE	Z-plane zero-pole plot
%	ZPLANE(Z,P) plots the zeros Z and poles P (in column vectors) with the 
%	unit circle for reference.  Each zero is represented with a 'o' and 
%	each pole with a 'x' on the plot.  Multiple zeros and poles are 
%	indicated by the multiplicity number shown to the upper right of the 
%	zero or pole.  ZPLANE(Z,P) where Z and/or P is a matrix plots the zeros
%	or poles in different columns with different colors.
%
%	If either argument is a row, ZPLANE finds the roots of the argument
%	with ROOTS.  So, ZPLANE(B,A) where B and A are row vectors containing
%	transfer function polynomial coefficients plots the poles and zeros
%	of B(z)/A(z).  ZPLANE assumes scalars are zeros or poles.
%
%	[H1,H2,H3]=ZPLANE(Z,P) returns vectors of handles to the lines and 
%	text objects generated.  H1 is a vector of handles to the zeros lines, 
%	H2 is a vector of handles to the poles lines, and H3 is a vector of 
%	handles to the axes / unit circle line and to text objects which are 
%	present when there are multiple zeros or poles.  In case there are no 
%	zeros or no poles, H1 or H2 is set to the empty matrix [].
%
%	See also FREQZ.

%	Author(s): T. Krauss, 3-19-93
%	Copyright (c) 1984-94 by The MathWorks, Inc.
%       $Revision: 1.11 $  $Date: 1994/01/25 18:00:11 $

    if (nargin<2),
        p=[];
    end;
   
    if (prod(size(z))==size(z,2))     % convert row vector to zeros
        if prod(size(z))>1   %  (but not if it's a scalar)
            z = roots(z);
        end
    end
    if (prod(size(p))==size(p,2))     % convert row vector to poles
        if prod(size(p))>1   %  (but not if it's a scalar)
            p = roots(p);
        end
    end

    ax = gca;

    if ~any(imag(z)),
        z = z + j*1e-50;
    end;
    if ~any(imag(p)),
        p = p + j*1e-50;
    end;
    newplot;
    if ~isempty(z),
        zh = plot(z,'o'); 
        hold on
    else
        zh = []; 
    end
    if ~isempty(p),
        ph = plot(p,'x','markersize',4); 
        hold on
    else
        ph = []; 
    end

    theta = linspace(0,2*pi,70);
    oh = plot(cos(theta),sin(theta),':');
	
    a = get(ax,'Aspect');
    set(ax,'Aspect',[a(1),1])

%  zoom out ever so slightly (5%)
    xl=get(ax,'xlim');
    d=diff(xl);
    xl = [xl(1)-.05*d  xl(2)+.05*d]; 
    set(ax,'xlim',xl); 
    yl=get(ax,'ylim');
    d=diff(yl);
    yl = [yl(1)-.05*d  yl(2)+.05*d]; 
    set(ax,'ylim',yl);

    axis(axis);

    set(oh,'xdat',[get(oh,'xdat') NaN ...
       xl(1)-diff(xl)*100 xl(2)+diff(xl)*100 NaN 0 0]);
    set(oh,'ydat',[get(oh,'ydat') NaN 0 0 NaN ...
       yl(1)-diff(yl)*100 yl(2)+diff(yl)*100]);

    handle_counter = 2;	
    fuzz = diff(xl)/80; % horiz spacing between 'o' or 'x' and number
    fuzz=0;
    [r,c]=size(z);
    if (r>1)&(c>1),  % multiple columns in z
        ZEE=z;
    else
        ZEE=z(:); c = min(r,c);
    end;
    for which_col = 1:c,      % for each column of ZEE ...
        z = ZEE(:,which_col);
        [mz,z_ind]=mpoles(z);
        for i=2:max(mz),
            j=find(mz==i);
            for k=1:length(j),
                x = real(z(z_ind(j(k)))) + fuzz;
                y = imag(z(z_ind(j(k))));
                if (j(k)~=length(z)),
                    if (mz(j(k)+1)<mz(j(k))),
                        oh(handle_counter) = text(x,y,num2str(i)); 
                        handle_counter = handle_counter + 1;
                    end
                else
                    oh(handle_counter) = text(x,y,num2str(i));
                    handle_counter = handle_counter + 1;
                end
            end
        end
    end
    [r,c]=size(p);
    if (r>1)&(c>1),  % multiple columns in z
        PEE=p;
    else
        PEE=p(:); c = min(r,c);
    end;
    for which_col = 1:c,      % for each column of PEE ...
        p = PEE(:,which_col);
        [mp,p_ind]=mpoles(p);
        for i=2:max(mp),
            j=find(mp==i);
            for k=1:length(j),
                x = real(p(p_ind(j(k)))) + fuzz;
                y = imag(p(p_ind(j(k))));
                if (j(k)~=length(p)),
                    if (mp(j(k)+1)<mp(j(k))),
                        oh(handle_counter) = text(x,y,num2str(i)); 
                        handle_counter = handle_counter + 1;
                    end
                else
                    oh(handle_counter) = text(x,y,num2str(i));
                    handle_counter = handle_counter + 1;
                end
            end
        end
    end
    set(oh(2:length(oh)),'vertical','bottom');
		
    hold off

    if (nargout==1),
        h1 = zh;
    elseif (nargout==2),
        h1 = zh;
        h2 = ph;
    elseif (nargout==3),
        h1 = zh;
        h2 = ph;
        h3 = oh;
    end

    xlabel('Real part')
    ylabel('Imaginary part')
