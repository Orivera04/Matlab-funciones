% INSTDELETE   �����ɓK�����鏤�i�������������Ƃɂ��A���i�̕����W��
%              �����S�Ȃ��̂ɂ��܂��B
%
%   ISubSet = instdelete(ISet, 'FieldName', FieldList, ... 
%                              'Data' , DataList, ...      
%                              'Index', IndexSet, ...
%                              'Type', TypeList)
%
% ����:
% �����̃p�����[�^�l�̑g��C�ӂ̏����œ��͂��邱�Ƃ��ł��܂��B�������A
% ��Ԗڂ̈����ɂ� ISet �ϐ�����͂��Ă��������B'FieldName' �y�� 'Data' 
% �p�����[�^���g�p����Ƃ��́A�������ɗp�����Ȃ���΂Ȃ�܂���(�ǂ��炩
% �Е��݂̂��g�p���邱�Ƃ͂ł��܂���)�B�Ȃ��A'Index' �y�� 'Type' �p��
% ���[�^�̓I�v�V�����ł��B
%
%   ISet       - ���i�̏W������Ȃ�ϐ��B���i�́A�^�C�v���ɕ��ނ���A��
%                �̂��ꂼ��̃^�C�v�ɂ��Č݂��ɈقȂ�f�[�^�t�B�[���h
%                ��ݒ肷�邱�Ƃ��ł��܂��B�L�����ꂽ�f�[�^�t�B�[���h��
%                ���i�̂��ꂼ��ɑΉ�����s�x�N�g���A�܂��́A�������
%                �Ȃ��Ă��܂��B
% 
%   FieldList - �f�[�^�l�ɓK������e�f�[�^�t�B�[���h�̖��̂����X�g�\����
%               �镶����A�܂��́A������ō\������� NFIELDS �s1��̃Z��
%               �z��B
%
%   DataList  - �e�t�B�[���h�ɓ��͂ł���f�[�^�l����Ȃ� NVALUES �s M ��
%               �̔z��A�܂��́ANFIELDS �s1��̃Z���z��ł��B���̔z���
%               �\�����邻�ꂼ��̍s�́A�Ή����� FieldList ���ŒT������
%               �f�[�^�s�̒l��\�����Ă��܂��B��̐��͔C�ӂŁA�p�f�B���O
%               �ɂ���ĕt�����ꂽ NaN �A�܂��́A�X�y�[�X�́A�����ɓK��
%               ���邩�ǂ����̃`�F�b�N���s���ۂɂ͖�������܂��B
%
%   IndexSet  - �K�����邩�ǂ����̃`�F�b�N�������鏤�i�̃|�W�V����������
%               ���� NINST �s1��̃x�N�g���ł��B�f�t�H���g�ł́A���i�ϐ�
%               ���ŗ��p�ł���S�ẴC���f�b�N�X�ɐݒ肳��Ă��܂��B
%
%   TypeList  - �K�����邩�ǂ����̃`�F�b�N���󂯂鏤�i�̃^�C�v�����肷��
%               ������A�܂��́A�����񂩂�Ȃ� NTYPE �s1��̃Z���z��ł��B
%               �f�t�H���g�ł́A���i�ϐ����\������S�Ẵ^�C�v�ɐݒ肳��
%               �Ă��܂��B
%
% �o��:
%   ISubSet   - ���͂��ꂽ��ɓK�����Ȃ����i���܂ޕϐ��ł��BField, 
%               Index, Type �̑S�Ă̏����ɓK�����鏤�i�́AISubSet ����
%               �폜����܂��BFieldName �ɑΉ����� DataList �ɋL�ڂ����
%               ���邢���ꂩ�̍s�ƋL�����ꂽ FieldName �f�[�^���K������
%               �Ƃ����i�͌X�� Field �����ƓK���������ƂɂȂ�܂��B
%
% ���ӁF
% ��葽���̓K����̗���Q�Ƃ���ɂ́A"help instfind" �ƃ^�C�v���Ă���
% �����B
%
% ���:
% 1) �f�[�^�t�@�C������ InstSet �ϐ� ExampleInst ���擾���܂��B�ϐ���
%    �ɂ́A����3�̃^�C�v�̏��i���܂܂�Ă��܂��B
%    'Option', 'Futures',  'TBill'
%
%      load InstSetExamples.mat
%      instdisp(ExampleInst)
%
% 2) �V�����ϐ� ISet ����I�v�V������S�ď������܂��B
%   ISet = instdelete(ExampleInst, 'Type','Option');
%   instdisp(ISet)
%
% �Q�l : INSTSELECT, INSTFIND, INSTGET, INSTADDFIELD.


%   Author(s) : J. Akao 31-Mar-1999
%   Copyright 1995-2002 The MathWorks, Inc. 
