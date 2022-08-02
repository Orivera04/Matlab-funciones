% INSTFIELDS   ���i�ϐ��ɋL������Ă���t�B�[���h�̃��X�g�𒊏o���܂��B
%
% ���̊֐��́A�t�B�[���h���y�уt�B�[���h�̃f�[�^�X�g���[�W�N���X�̖₢
% ���킹���s���֐��ł��B
%
%   [FieldList, ClassList] = instfields(InstSet, 'Type', TypeList)
%   [FieldList, ClassList] = instfields(InstSet)
%
% ����: 
%   InstSet   - ���i�̏W������Ȃ�ϐ��B���i�́A�^�C�v���ɕ��ނ���A����
%               ���ꂼ��̃^�C�v�ɂ��Č݂��ɈقȂ�f�[�^�t�B�[���h���
%               �肷�邱�Ƃ��ł��܂��B�L�����ꂽ�f�[�^�t�B�[���h�́A���i
%               �̂��ꂼ��ɑΉ�����s�x�N�g���A�܂��́A������ƂȂ��Ă�
%               �܂��B
%   TypeList  - �����ΏۂƂȂ鏤�i�^�C�v�����X�g�A�b�v����������A�܂���
%               �����񂩂�Ȃ� NTYPE �s1��̃Z���z��
%
% �o��:
%   FieldList - ���X�g�A�b�v���ꂽ���i�^�C�v�ɑΉ�����f�[�^�t�B�[���h��
%               ���̂����X�g�\�����镶���񂩂�Ȃ� NFIELDS �s1��̃Z���z
%               ��B
%   ClassList - DataList ���\������e�t�B�[���h�̃f�[�^�N���X���L�ڂ���
%               �����񂩂�Ȃ� NFIELDS �s1��̃Z���z��ł��B�����ɋL�ڂ�
%               ���f�[�^�N���X�ɂ���āA���̓f�[�^�̉��ߖ@�����肳���
%               ���B���͉\�Ȉ����́A'dble', 'date',  'char'�ł��B 
%     
% ���:
% 1) InstSet �ϐ�, ExampleInst ���f�[�^�t�@�C������擾���܂��B
%
%   load InstSetExamples.mat
%   instdisp(ExampleInst)
%
% 2) 'Option' �^�C�v�ɑΉ�����t�B�[���h�����X�g�\�����܂��B
%   [FieldList, ClassList] = instfields(ExampleInst, 'Type', 'Option')
%
% 3) 'Option' �y�� 'TBill' ��2�̃^�C�v�ɑΉ�����t�B�[���h�����X�g
%       �\�����܂��B
%   FieldList = instfields(ExampleInst, 'Type', {'Option', 'TBill'})
%
% 4) �ϐ����\������S�Ẵ^�C�v�ɑΉ�����t�B�[���h�����X�g�\�����܂��B
%   FieldList = instfields(ExampleInst)
%
% �Q�l : INSTTYPES, INSTLENGTH, INSTDISP.


%   Copyright 1995-2002 The MathWorks, Inc. 
