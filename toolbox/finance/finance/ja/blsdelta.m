% BLSDELTA   原価格の変化に対するBlack-Scholesの感応度
%
% [CD,PD] = BLSDELTA(SO,X,R,T,SIG,Q)は、原証券価格の変化に対するオプション
% 価値の変動率を出力します。デルタは、ヘッジ比率とも呼ばれます。SO は
% 現行株価、X は権利行使価格、R は安全利子率、T はオプションの満期までの
% 年数、SIG は年率換算した株式の連続複利収益率の標準偏差(ボラティリティ
% とも言います)、Q は配当率、あるいは、該当する場合の外国金利です。
% Q のデフォルトは、Q = 0です。CD はコールオプションのデルタ、PD はプット
% オプションのデルタです。
%        
% 注意： 
% この関数は、Statistics Toolboxの正規累積分布関数 normcdf を使用します。
%  
% たとえば、[c,p] = blsdelta(50,50,.1,.25,.3,0) は、c = 0.5955 及び 
% p = -0.4045 を出力します。
% 
% 参考 : BLSPRICE, BLSGAMMA, BLSTHETA, BLSRHO, BLSVEGA, BLSLAMBDA.
%  
% 参考文献: Options, Futures, and Other Derivative Securities, Hull, 
%           Chapter 13. 


%       Author(s): C.F. Garvin, 2-23-95  
%       Copyright 1995-2002 The MathWorks, Inc.   
