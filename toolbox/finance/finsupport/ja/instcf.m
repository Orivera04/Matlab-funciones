% INSTCF   'CashFlow' �^�C�v ���i�̍쐬�֐�
%
% �f�[�^�z�񂩂�V�������i�ϐ����쐬����ɂ́A���̂悤�ɐݒ肵�Ă���
% �����B
%   ISet = instcf(CFlowAmounts, CFlowDates, Settle, Basis)
%
% 'CashFlow' ���i�����i�ϐ��ɒǉ�����ɂ́A���̂悤�ɐݒ肵�Ă��������B
%   ISet = instcf(ISet, CFlowAmounts, CFlowDates, Settle, Basis)
%
% 'CashFlow' ���i�ɓK�p�����t�B�[���h���^�f�[�^�����X�g�\������ɂ́A
% ���̂悤�ɐݒ肵�܂��B
% 
%   [FieldList, ClassList, TypeString] = instcf;
%
% ���́F
% �f�[�^�����ɂ́ANINST �s MOSTCFS ��̍s��A�܂��́A��s�� [] �̂�����
% ������͂ł��܂��B���i�̐����ɂ́A������1�̃f�[�^�������K�v�Ƃ���A
% ���̃f�[�^�����͍폜�A�܂��́A��s�� []�Ƃ��ďȗ�����܂��B�S�Ă̓���
% �́A���̓f�[�^�̃N���X�ɉ����āAFINARGPARSE �ɂ���ĉ��߂���܂��B
% �f�[�^�̃N���X���Q�Ƃ���ɂ́A"[FieldList, ClassList] = instcf" ��
% �^�C�v���Ă��������B�Ȃ��A���t�ɂ��ẮA�V���A�����t�ԍ��A�܂��́A
% ���t������œ��͂��Ă��������B
%
%   CFlowAmounts - �L���b�V���t���[�z����Ȃ� NINST �s MOSTCFS ��̍s��
%                  �ł��B���̍s����\�����邻�ꂼ��̍s�́A�Ή�����1��
%                  �،��̃L���b�V���t���[�l�̃��X�g�ƂȂ��Ă��܂��B�،�
%                  �̃L���b�V���t���[���ANCFS �L���b�V���t���[��������
%                  ���ꍇ�A�s�̖����� NaN �Ńp�f�B���O����܂��B
%   CFlowDates   - �L���b�V���t���[���t������ NINST �s MOSTCFS ��̍s��
%                  �ł��B���̍s��̊e���͒l�́ACFlowAmounts ���̑Ή�����
%                  �L���b�V���t���[�̃V���A�����t�������Ă��܂��B
%   Settle       - ���ϓ�
%   Basis        - �����̃J�E���g��B�f�t�H���g��0(actual/actual).
%
%  �o��:
%   ISet         - ���i�̏W������Ȃ�ϐ��B���i�́A�^�C�v���ɕ��ނ���A
%                  ���̂��ꂼ��̃^�C�v�ɂ��Č݂��ɈقȂ�f�[�^�t�B�[
%                  ���h��ݒ肷�邱�Ƃ��ł��܂��B�L�����ꂽ�f�[�^�t�B�[
%                  ���h�́A���i�̂��ꂼ��ɑΉ�����s�x�N�g���A�܂��́A
%                  ������ƂȂ��Ă��܂��B�ϐ� ISet �Ɋւ���ڍׂɂ���
%                  �́A"help instget" �ƃ^�C�v���Ă��������B
% 
%   FieldList    - ���̏��i�^�C�v�ɓK�p�����f�[�^�t�B�[���h�̖��̂���
%                  �X�g�\�����镶����ō\������� NFIELDS �s1��̃Z���z
%                  ��B
% 
%   ClassList    - �e�t�B�[���h�̃f�[�^�N���X���L�ڂ��镶���񂩂�Ȃ� 
%                  NFIELDS �s1��̃Z���z��A�����ɁA�L�ڂ����f�[�^�N��
%                  �X�ɂ���āA�����̉��ߖ@�����肳��܂��B���͉\��
%                  �����́A'dble', 'date',  'char' �ł��B 
%   TypeString   - �ǉ�����鏤�i�̃^�C�v���w�肷�镶����ł��B
%                  TypeString = 'CashFlow'.
%
% �Q�l : INSTARGCF, INSTADDFIELD, INSTGET, INSTDISP, INTENVPRICE, 
%        HJMPRICE.


%   Author(s): J. Akao 9-Mar-1999
%   Copyright 1995-2002 The MathWorks, Inc. 
