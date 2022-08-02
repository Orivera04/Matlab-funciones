% INSTCF   'CashFlow' タイプ 商品の作成関数
%
% データ配列から新しい商品変数を作成するには、つぎのように設定してくだ
% さい。
%   ISet = instcf(CFlowAmounts, CFlowDates, Settle, Basis)
%
% 'CashFlow' 商品を商品変数に追加するには、つぎのように設定してください。
%   ISet = instcf(ISet, CFlowAmounts, CFlowDates, Settle, Basis)
%
% 'CashFlow' 商品に適用されるフィールドメタデータをリスト表示するには、
% つぎのように設定します。
% 
%   [FieldList, ClassList, TypeString] = instcf;
%
% 入力：
% データ引数には、NINST 行 MOSTCFS 列の行列、または、空行列 [] のいずれ
% かを入力できます。商品の生成には、たった1つのデータ引数が必要とされ、
% 他のデータ引数は削除、または、空行列 []として省略されます。全ての入力
% は、入力データのクラスに応じて、FINARGPARSE によって解釈されます。
% データのクラスを参照するには、"[FieldList, ClassList] = instcf" と
% タイプしてください。なお、日付については、シリアル日付番号、または、
% 日付文字列で入力してください。
%
%   CFlowAmounts - キャッシュフロー額からなる NINST 行 MOSTCFS 列の行列
%                  です。この行列を構成するそれぞれの行は、対応する1つの
%                  証券のキャッシュフロー値のリストとなっています。証券
%                  のキャッシュフローが、NCFS キャッシュフローよりも少な
%                  い場合、行の末尾は NaN でパディングされます。
%   CFlowDates   - キャッシュフロー日付を示す NINST 行 MOSTCFS 列の行列
%                  です。この行列の各入力値は、CFlowAmounts 内の対応する
%                  キャッシュフローのシリアル日付を示しています。
%   Settle       - 決済日
%   Basis        - 日数のカウント基準。デフォルトは0(actual/actual).
%
%  出力:
%   ISet         - 商品の集合からなる変数。商品は、タイプ毎に分類され、
%                  そのそれぞれのタイプについて互いに異なるデータフィー
%                  ルドを設定することができます。記憶されたデータフィー
%                  ルドは、商品のそれぞれに対応する行ベクトル、または、
%                  文字列となっています。変数 ISet に関する詳細について
%                  は、"help instget" とタイプしてください。
% 
%   FieldList    - この商品タイプに適用されるデータフィールドの名称をリ
%                  スト表示する文字列で構成される NFIELDS 行1列のセル配
%                  列。
% 
%   ClassList    - 各フィールドのデータクラスを記載する文字列からなる 
%                  NFIELDS 行1列のセル配列、ここに、記載されるデータクラ
%                  スによって、引数の解釈法が決定されます。入力可能な
%                  引数は、'dble', 'date',  'char' です。 
%   TypeString   - 追加される商品のタイプを指定する文字列です。
%                  TypeString = 'CashFlow'.
%
% 参考 : INSTARGCF, INSTADDFIELD, INSTGET, INSTDISP, INTENVPRICE, 
%        HJMPRICE.


%   Author(s): J. Akao 9-Mar-1999
%   Copyright 1995-2002 The MathWorks, Inc. 
