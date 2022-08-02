% INSTGET   ���i�ϐ�����f�[�^�z��𒊏o
%
%    [Data_1, Data_2, ... Data_NFIELDS ] = instget(InstSet, ...
%                                        'FieldName', FieldList, ...
%                                        'Index', IndexSet, ...
%                                        'Type', TypeList)
%
% ����:
% �����̑g�̃p�����[�^�l��C�ӂ̏����œ��͂ł��܂��B�A���A��Ԗڂ̈�����
% �́A�K�� InstSet �ϐ�����͂��Ă��������BInstSet �ϐ��͕K�{�ł��B
%
%   InstSet      - ���i�̏W������Ȃ�ϐ��B���i�́A�^�C�v���ɕ��ނ���A
%                  ���̂��ꂼ��̃^�C�v�ɂ��Č݂��ɈقȂ�f�[�^�t�B�[
%                  ���h��ݒ肷�邱�Ƃ��ł��܂��B�L�����ꂽ�f�[�^�t�B�[
%                  ���h�́A���i�̂��ꂼ��ɑΉ�����s�x�N�g���A�܂��́A
%                  ������ƂȂ��Ă��܂��B
%
%   FieldList    - �e�f�[�^�t�B�[���h�̖��̂����X�g�\�����镶����A�܂�
%                  �́A���̕�����ō\������� NFIELDS �s1��̃Z���z��B
%                  FieldList �ɂ��Ă��A'Type' �� 'Index' �̂����ꂩ��
%                  ���͂ł��܂��B���̂����ꂩ����͂���΁A����ɑΉ���
%                  �ă^�C�v������������A�܂��́A�C���f�b�N�X�i���o�[��
%                  �o�͂���܂��B�f�t�H���g�ł́A�S�Ẵt�B�[���h���o��
%                  ���ꂽ���i�Z�b�g�ɂ��ė��p�\�ƂȂ��Ă��܂��B
%
%   TypeList     - ���s�ΏۂƂȂ鏤�i�̃^�C�v�� TypeList �ɋL�ڂ��ꂽ�^
%                  �C�v�ɓK��������̂ɐ��񂷂镶����A�܂��́A������
%                  ��Ȃ� NTYPE �s1��̃Z���z��B�f�t�H���g�ł́A���i��
%                  �����̑S�Ẵ^�C�v���ΏۂƂȂ��Ă��܂��B
%
%   IndexSet     - ���s�ΏۂƂȂ鏤�i�̃|�W�V���������� NINST �s1��̃x
%                  �N�g���ł��BTypeList �������ɐݒ肳�ꂽ�ꍇ�A�Q�Ƃ���
%                  �鏤�i�́ATypeList �ɋL�ڂ��ꂽ�A�����ꂩ1�̃^�C�v
%                  �ł���Ɠ����ɁAIndexSet �Ɋ܂܂�Ă��鏤�i�łȂ����
%                  �Ȃ�܂���B�f�t�H���g�ł́A���i�ϐ��̑S�ẴC���f�b
%                  �N�X�����p�\�ƂȂ��Ă��܂��B
%
% �o��:
%
%   Data_1       - FieldList �̍ŏ��̃t�B�[���h�ɑΉ�����f�[�^���e����
%                  �Ȃ� NINST �s M ��̔z��B���̔z����\�����邻�ꂼ��
%                  �̍s�́AIndexSet �Ɋ܂܂��ʁX�̏��i�ɂ��ꂼ��Ή���
%                  �Ă��܂��B���p�\�łȂ��f�[�^�ɂ��ẮANaN �܂���
%                  �X�y�[�X�ŏo�͂���܂��B
%
%   Data_NFIELDS - FieldList �̍Ō�̃t�B�[���h�ɑΉ�����f�[�^���e����
%                  �Ȃ� NINST �s M ��̔z��B
%
% ���F
% 1) InstSet �ϐ��AExampleInst ���f�[�^�t�@�C������擾���܂��B���̕ϐ�
%    �̒��ɂ́A����3�̃^�C�v�̏��i���܂܂�Ă��܂��B
%    'Option', 'Futures', 'TBill'
%
%    load InstSetExamples.mat
%    instdisp(ExampleInst)
%
%    Index Type   Strike Price Opt  Contracts
%    1    Option  95    12.2  Call     0    
%    2     Option 100     9.2  Call     0    
%    3     Option 105     6.8  Call  1000    
%     
%    Index Type    Delivery       F     Contracts
%    4     Futures 01-Jul-1999    104.4 -1000    
%    
%    Index Type   Strike Price Opt  Contracts
%    5     Option 105     7.4  Put  -1000    
%    6     Option  95     2.9  Put      0    
%    
%    Index Type  Price Maturity       Contracts
%    7     TBill 99    01-Jul-1999    6        
%
% 2) �S�Ă̏��i���牿�i�𒊏o���܂��B
%   P = instget(ExampleInst,'FieldName','Price')
%   
% 3) ���i�ƕێ����Ă���_�񐔂̑o�����擾���܂��B
%   [P,C] = instget(ExampleInst, 'FieldName', {'Price', 'Contracts'})
%   
% 4) ���l V ���v�Z���A���̌��ʂ�ϐ� ISet �ɋL�����܂��B
%   V = P.*C
%   ISet = instsetfield(ExampleInst, 'FieldName', 'Value', 'Data', V);
%   instdisp(ISet)
%   
% 5) �[���łȂ��_���L����،��݂̂𒊏o���܂��B
%   Ind = find( C ~= 0 )
%   
% 6) ���i���� Type �y�� Opt �p�����[�^���擾���܂��B
%    �I�v�V�����̂� 'Opt' �t�B�[���h�ɋL�����܂��B
%   [T,O] = ...
%    instget(ExampleInst, 'Index', Ind, 'FieldName', {'Type', 'Opt'})
%   
% 7) Type, Opt, Value ��3�̃p�����[�^���܂ޕ�����̃��|�[�g���o�͂�
%    �܂��B
%   rstring = [T, O, num2str(V(Ind))]
%
% �Q�l : INSTGETCELL, INSTADDFIELD, INSTSETFIELD, INSTDISP.


%   Copyright 1995-2002 The MathWorks, Inc. 
