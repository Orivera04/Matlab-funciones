% BLSVEGA   原価格のボラティリティに対するBlack-Scholesの感応度
%
% V = BLSVEGA(SO,X,R,T,SIG,Q) は、原資産のボラティリティに対するオプション
% の価値の変化率を出力します。SO は現行株価、X は権利行使価格、R は安全
% 利子率、T はオプションの満期までの年数、SIG は年率換算した株式の連続
% 複利収益率の標準偏差(ボラティリティとも言います)、Q は配当率です。
% Q のデフォルトは0です。
%
% 注意：この関数は、Statistics Toolboxの正規確率密度関数 normpdf を
% 使用します。
% 
% たとえば、v = blsvega(50,50,.12,.15,.3,0) は、v = 7.5522 を出力します。
%
%
% 参考 : BLSPRICE, BLSDELTA, BLSGAMMA, BLSTHETA, BLSRHO, BLSLAMBDA. 


%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
