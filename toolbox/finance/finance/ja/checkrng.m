% CHECKRNG   上限及び下限について入力引数をテスト
%
% ECODE = CHECKRNG(ARG_NAMES,ACTUAL,LOW,UP,LOWNAME,UPNAME,LEQ,UEQ,FUN) 
% は、与えられた引数が指定された境界条件に適合しているかどうかを検証し
% ます。この関数は、入力引数のレンジチェックを実行するために、Financial 
% Toolbox の関数から呼び出されます。ARG_NAMES は、関数の入力引数の名称を
% 示す文字列行列です。ACTUAL は、与えられた入力引数の実際の値です。
% LOW は下限値、UP は上限値、LOWNAME はより低い限界値をもつ変数の名称、
% または、文字列の行列、UPNAME はより高い限界値をもつ変数の名称、または
% 文字列の行列です。LEQ を 'e' に設定すると、入力引数の値は LOW よりも大
% きい値、または、等しい値に制限されます。UEQ を 'e' に設定すると、入力
% 引数は UP よりも小さい値、または、UP と等しい値に制限されます。 LEQ = 
% 'l' 及び UEQ = 'l' は、入力引数を LOW よりも大きい値及び UP よりも小さ
% い値に制限します。FUN は、CHECKRNG を呼び出す関数の名称です。境界条件
% が満たされない場合には、ECODE =1が出力されます。
%
% 例題：
% checkrng('rate',0.1,0,inf,'0','inf','e','l',mfilename) は、rate という
% 名称の入力引数が0と無限大の間にあるかどうかをチェックします。この範囲
% 外の値の場合、エラーメッセージが出力されます。


%       Author(s): C.F. Garvin, 7-18-95
%       Copyright 1995-2002 The MathWorks, Inc. 
