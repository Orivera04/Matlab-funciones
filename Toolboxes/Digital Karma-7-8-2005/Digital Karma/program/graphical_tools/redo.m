if exist ('a')
    if isempty(redovalue{1,currentwindow})==0;
        save_undo;        
        redomatrix=redovalue{1,currentwindow};
        a=redomatrix{end,1};
        totaliterationscompleted=redomatrix{end,2};
        redomatrix=redomatrix(1:end-1,:);
        redovalue{1,currentwindow}=redomatrix;
    end;
end;