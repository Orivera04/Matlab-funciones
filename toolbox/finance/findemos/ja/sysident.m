% SYSIDENT   システム同定データ予測
%
% OUT = SYSIDENT(FUN,INDATA,X) は、System Identification Toolbox モデルを
% 用いて、時系列のつぎの値の予測を行います。FUN は予測に用いるモデル
% (例 'ar ')、INDATA は、解析に使用する入出力データ、X は多項式の係数
% です。
%
% 例題：
% sysident('bj',[ibm(:,4)ibm(:,5)ibm(:,3],10)


%       Author(s): C.F.Garvin
%       Copyright 1995-2002 The MathWorks, Inc.
