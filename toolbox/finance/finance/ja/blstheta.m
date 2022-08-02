% BLSTHETA   満期までの年数に対するBlack-Scholesの感応度
%
% [CT,PT] = BLSTHETA(SO,X,R,T,SIG,Q)は、時間との関連においてオプションの
% 価値の感応度を出力します。SO は現行株価、X は権利行使価格、R は安全
% 利子率、T はオプションの満期までの年数、SIG は年率換算した株式の連続
% 複利収益率の標準偏差(ボラティリティとも言います)、Q は配当率です。
% Q のデフォルトは 0です。CT はコールオプションのシータ、PT はプット
% オプションのシータです。
%        
% 注意： 
% この関数は、Statistics Toolboxの正規確率密度関数 normpdf と正規累積
% 分布関数 normcdf を使用します。
% 
% たとえば、[c,p] = blstheta(50,50,.12,.25,.3,0) は、c = -8.9630 と 
% p = -3.1404 を出力します。
% 
% 参考 : BLSPRICE, BLSDELTA, BLSGAMMA, BLSRHO, BLSVEGA, BLSLAMBDA.
% 
% 参考文献：Hull, Options, Futures, and Other Derivative Securities,  
%           2nd Edition, Chapter 13. 


%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
