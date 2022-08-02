%  plays the movie:  movie(graphmovie,0);
timenow=num2str(datestr(now,30));
movie2avi(graphmovie,['Iteration_Movie_',num2str(timenow(1,10:11)),'.', num2str(timenow(1,12:13)),'.', num2str(timenow(1,14:15)),'__', num2str(timenow(1,5:6)),'.', num2str(timenow(1,7:8)),'.', num2str(timenow(1,1:4)),'.','avi']);