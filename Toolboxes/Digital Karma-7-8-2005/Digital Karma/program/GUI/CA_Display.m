if exist('a');

% currentiteration must be set from outside
gui_display_set;

% Activates right-click on the image
if gcf==digitalkarma; set(findobj(CAgraph,'flat'),'uicontextmenu',findobj('Tag','rightclick')); end;

%Graph Update
if making_avi==0; erasemodevariable=['none']; else; erasemodevariable=['normal']; end; %Enables erasemode during movie creation
if dimension==2;
    b=a(firstrow:firstrow+rowsshown-1,firstcolumn:firstcolumn+columnsshown-1,(currentiteration+1));
    set(CAgraph,'CData',b,'EraseMode',erasemodevariable);
    set(gca,'CLim',[low high]); colormap(colordisplay); axis off; drawnow;
elseif dimension==1;
    agraphing=a(1:currentiteration+1,firstcolumn:firstcolumn+columnsshown-1);
    [agraphingrows,agraphingcols]=size(agraphing);
    if agraphingrows<=rows;
        addingzeros=zeros((rows-agraphingrows),agraphingcols);
        b=cat(1,addingzeros,agraphing);
    else;
        agraphing=a(currentiteration-rows+2:currentiteration+1,firstcolumn:firstcolumn+columnsshown-1);
        b=agraphing;
    end

    % Rotates display, but A is unchanged
    if strcmp(iterationdirection,'up');
    elseif strcmp(iterationdirection,'left'); b=b';
    elseif strcmp(iterationdirection,'down'); b=flipdim(b,1);
    elseif strcmp(iterationdirection,'right'); b=b'; b=flipdim(b,2); end;
    
    set(CAgraph,'CData',b,'EraseMode',erasemodevariable);
    set(gca,'CLim',[low high]); colormap(colordisplay); axis off;
    drawnow;
end

if currentlyselecting==1 | exist('byteselection');
    opening_iteration;
    if currentlyselecting==1; selection_drawing; end;
    if exist('byteselection'); byte_drawing; end;
end;

if making_avi==1; currentframe=getframe; aviobj = addframe(aviobj,currentframe); end;
if  (displayselectionvalues==1) | (displaygraphvalues==1) | (displayallvalues==1) | (displaytotaliterations==1) | (bytevalueson==1); run display_values; end;
if gridlinesvalue==1; axis on; grid on;
    if dimension==1; set(gca,'ytick',[0.5:rows+0.5]);
    elseif dimension==2; set(gca,'ytick',[0.5:rowsshown+0.5]); end;
    set(gca,'xtick',[0.5:columns+0.5]);
end;
% Squareforce & colorbar should not be set each time.

end;