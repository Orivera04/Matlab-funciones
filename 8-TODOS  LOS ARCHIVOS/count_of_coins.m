%% COUNT OF COINS
% Ing. Diego Barragán Guerrero
% www.matpic.com - www.eqbyte.com
%% Convert image to BW
coin1 = im2bw(imread('coins.png'));
%% Fill image regions and holes
coin2 = imfill(coin1,'holes');
%% Label and count connected components
[L Ne]=bwlabel(double(coin2));
%% Measure properties of image regions
prop=regionprops(L,'Area','Centroid');
%% Counter
total=0;
%% Show image
imshow(imread('coins.png'));hold on
%% Money count based on area of coin
for n=1:size(prop,1) %For 1 to Total number of coins
    cent=prop(n).Centroid;
    X=cent(1);Y=cent(2);
    if prop(n).Area>2000
        text(X-10,Y,'5 C') 
        total=total+5;
    else
        total=total+10;
        text(X-10,Y,'10 C') 
    end
end
hold on
title(['Total of money: ',num2str(total),' Cents'])