% INSTOPTBND   'OptBond' タイプ商品の作成関数
%
% 欧州オプション、または、バミューダオプションを指定するには、つぎのよう
% に設定します。
% 
%   InstSet = instoptbnd(BondIndex, OptSpec, Strike, ExerciseDates)
%   InstSet = ....
%    instoptbnd(BondIndex, OptSpec, Strike, ExerciseDates, AmericanOpt)
%
% 米国オプションを指定するには、つぎのように設定します。
% 
%   InstSet = instoptbnd(BondIndex, OptSpec, Strike, ...
%           ExerciseDates, AmericanOpt)
%
%   'OptBond'商品を商品変数に追加するには、つぎのように設定します。
% 
%   InstSet = instoptbnd(InstSetOld, OptSpec, ... )
%
%   'OptBond' 商品のフィールドメタデータをリスト表示するには、つぎのよう
%   に設定します。
%   [FieldList, ClassList, TypeString] = instoptbnd;
%
% 入力: 
% ベクトル内の指定のない要素については、NaN 値が入力されます。商品の生成
% には、たった1つのデータ引数が必要とされ、他のデータ引数は削除、または
% 空行列 []として省略されます。全ての入力は、入力データのクラスに応じて
% FINARGPARSE を使って解釈されます。データのクラスを参照するには、
% "[FieldList, ClassList] = instoptbnd" とタイプしてください。なお、
% 日付については、シリアル日付番号、または、日付文字列で入力してください。
%
%   BondIndex     - 商品を指示するインデックスを示す NINST 行1列のベクト
%                   ル、このベクトルで示される 'Bond' タイプの基礎商品は
%                   InstSet 変数にも記憶されます。債券データの指定につい
%                   ては、 "help instbond" をタイプしてください。
% 
%   OptSpec       - 'Call'、または、'Put' のいずれかの文字列からなる 
%                    NINST 行1列のリスト
%   
% 欧州、または、バミューダオプションについては、つぎのパラメータが適用さ
% れます。
%
%   Strike        - 権利行使価格の NINST 行 NSTRIKES 列の行列です。行列
%                   の各行は、あるオプションのスケジュールとなっています。
%                   オプションがNSTRIKES で示される権利行使機会の回数よ
%                   りも少ない場合、行の末尾は、NaN でパディングされます。
% 
%   ExerciseDates - 権利行使日付の NINST 行 NSTRIKES 列の行列です。行列
%                   の各行は、あるオプションのスケジュールとなっています。
%                   欧州オプションでは、権利行使日は、オプションの期限満
%                   了日(満期日)の1日のみです。
% 
%   AmericanOpt   - NINST 行1列のベクトルフラグです。欧州、または、バミ
%                   ューダオプションでは、AmericanOpt は、ゼロに設定しま
%                   す。AmericanOpt が、NaN 、または、未入力の場合、この
%                   フラグはデフォルトの0に設定されます。
%
% 米国オプションについては、つぎのパラメータが適用されます。
%
%   Strike        - 各オプションに対応する権利行使価格の NINST 行1列のベ
%                   クトル
%   ExerciseDates - 権利行使期限の NINST 行 2 列のベクトルです。このベク
%                   トルの行に示される2つの日付間に位置するクーポン日(ま
%                   たは、この2つの日付のいずれかと一致するクーポン日)で
%                   あれば、 いずれの日でも、その商品についてオプション
%                   の権利を行使することができます。値が、NaN でない日付
%                   がたった1つだけ入力された場合、または、ExerciseDates
%                   が、NINST 行1列のベクトルであった場合、基礎証券の決
%                   済日と ExerciseDate で指定された単一の日付との間の期
%                   間において、オプションの権利行使は可能であると解釈さ
%                   れることになります。
%   AmericanOpt 　- NINST 行1列のベクトルフラグです。米国オプションの場
%                   合、AmericanOpt は1に設定します。AmericanOpt 引数は
%                   米国の権利行使ルールを呼び出す場合には必須となります。
%   
% 出力:
%   ISet 　　　　-　商品の集合からなる変数。商品は、タイプ毎に分類され、
%                   そのそれぞれのタイプについて互いに異なるデータフィー
%                   ルドを設定することができます。記憶されたデータフィー
%                   ルドは、商品のそれぞれに対応する行ベクトル、または、
%                   文字列となっています。変数 ISet に関する詳細について
%                   は、"help instget" とタイプしてください。
% 
%   FieldList 　　- この商品タイプに適用されるデータフィールドの名称をリ
%                   スト表示する文字列で構成される NFIELDS 行1列のセル配
%                   列。
% 
%   ClassList 　　- 各フィールドのデータクラスを記載する文字列からなる 
%                   NFIELDS 行1 列のセル配列、ここに記載されるデータクラ
%                   スによって、引数の解釈法が決定されます。入力可能な引
%                   数は、'dble', 'date',  'char' です。 
% 
%   TypeString 　 - 追加される商品のタイプを指定する文字列です。
%                   TypeString = 'Bond'.
%
% 参考 : INSTADD, INSTGET, INSTDISP, HJMPRICE.


%   Author(s): M. Reyes-Kattar 04/25/99
%   Copyright 1995-2002 The MathWorks, Inc. 
