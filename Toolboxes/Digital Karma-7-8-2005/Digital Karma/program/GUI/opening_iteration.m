gui_display_set;

if dimension==1;
    if columns-firstcolumn+1<columnsshown; columnsshown=columns;
        set(findobj('Tag','columnsinputbox'), 'string', columnsshown); end;
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

    CAgraph=image(b,'CDataMapping','scaled','EraseMode','none');
    set(gca,'CLim',[low high]); colormap(colordisplay); axis off;
else;
    if columns-firstcolumn+1<columnsshown; columnsshown=columns;
        set(findobj('Tag','columnsinputbox'), 'string', columnsshown); end;
    if totalrows-firstrow+1<rowsshown; rowsshown=totalrows;
        set(findobj('Tag','rowsinputbox'), 'string', rowsshown); end;
    CAgraph=image(a(firstrow:firstrow+rowsshown-1,firstcolumn:firstcolumn+columnsshown-1,...
        (currentiteration+1)),'CDataMapping','scaled','EraseMode','none');
    set(gca,'CLim',[low high]); colormap(colordisplay); axis off;
end;
if squareforce==1; axis image; end
if gridlinesvalue==1; axis on; grid on;
    if dimension==1; set(gca,'ytick',[0.5:rows+0.5]);
    elseif dimension==2; set(gca,'ytick',[0.5:rowsshown+0.5]); end;
    set(gca,'xtick',[0.5:columns+0.5]);
end;
if colorbarvalue==1; colorbar; end;
