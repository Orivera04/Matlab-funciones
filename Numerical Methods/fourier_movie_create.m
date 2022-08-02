%% CREATING A MOVIE OF CONVERGENCE OF A FOURIER SERIES
%% Creating a movie
% The command *fourier_movie* will create an animation or movie of the first n
% partial sums of the Fourier series of the expression f on the interval
% [a,b]. You will want to download fourier_movie.m to use it.  
% Here is the code for the command.

type fourier_movie
 
%% Example 1:  ||x||
syms x
f = abs(x); a= -1; b=1; n=20;

%%
% This command creates the movie.  
absx = fourier_movie(f,x,-1,1,20);
%% Viewing the movie
% You can view it with *mplay*.

mplay(absx)


%% Saving the example
% You can save it as *name.mat* (replace "name" by the name you
% want) with the command *save('name','mymovie')* where mymovie is the name
% you gave the output of your fourier_movie command. Then you can load it 
% during another MATLAB session with the command *load('name')*.  The movie will
% then be named 'mymovie'.  This command saves the example as absx.mat.
save('absx','absx')
%%
% You can use different names for the two arguments in the save command,
% but when you load name.mat with the command *load('name')*, the movie
% will be named mymovie.
%
% You can close mplay windows with the command
close all hidden
%% Example 2: x
% Since the convergence of the series is
% slower for this function, we take the first 50 partial sums.

f = x
xmovie = fourier_movie(f,x,-1,1,50);
%%
mplay(xmovie)

close all hidden
%% Example 3: exp(x)
% I'll take 20 partial
% sums on [0,5].

f = exp(x)
expmovie = fourier_movie(f,x,0,5,20);

%%
mplay(expmovie)