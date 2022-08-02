function Movie_from_frames(name,filetype,number_of_frames,display_time_of_frame)
mov = avifile('MOVIE.avi');
count=0;
for i=1:number_of_frames
    name1=strcat(name,num2str(i),filetype);
    a=imread(name1);
    while count<display_time_of_frame
        count=count+1;
        imshow(a);
        F=getframe(gca);
        mov=addframe(mov,F);
    end
    count=0;
end
close all
mov=close(mov);
    