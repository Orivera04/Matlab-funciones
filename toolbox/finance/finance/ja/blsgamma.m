% BLSGAMMA   デルタの変化に対するBlack-Scholesの感応度
%
% G = BLSGAMMA(SO,X,R,T,SIG) は、原証券価格の変化に対するデルタの感応度
% を出力します。SO は現行株価、X は権利行使価格、R は安全利子率、
% T はオプションの満期までの年数、SIG は年率換算した株式の連続複利収益率
% の標準偏差(ボラティリティとも言います)、Q は配当率です。Q のデフォルト
% は、Q = 0です。
%        
% 注意： 
% この関数は、Statistics Toolboxの正規確率密度関数 normpdf を使用します。
% 
% たとえば、g = blsgamma(50,50,.12,.25,.3,0) は、g = 0.0512 を出力
% します。 
% 
% 参考 : BLSPRICE, BLSDELTA, BLSTHETA, BLSRHO, BLSVEGA, BLSLAMBDA.


%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
