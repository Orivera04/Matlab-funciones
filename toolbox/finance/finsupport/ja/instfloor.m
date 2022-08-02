% INSTFLOOR   'Floor'�^�C�v ���i�̍쐬�֐�
%
% �f�[�^�z�񂩂�V�������i�𐶐�����ɂ́A���̂悤�ɐݒ肵�Ă��������B
% 
%   ISet = instfloor(Strike, Settle, Maturity, Reset, Basis, Principal)
%
% 'Floor' ���i�����i�ϐ��ɒǉ�����ɂ́A���̂悤�ɐݒ肵�Ă��������B
%   ISet = instfloor(ISet, Strike, Settle, Maturity, Reset, Basis, ....
%        Principal)
%
% 'Floor' ���i�ɓK�p�����t�B�[���h���^�f�[�^�����X�g�\������ɂ́A��
% �̂悤�ɐݒ肵�܂��B
% 
%   [FieldList, ClassList, TypeString] = instfloor;
%
% ����:
% �f�[�^�����ɂ́ANINST �s1��̃x�N�g���A�X�J���A�܂��́A��̂����ꂩ��
% ���͂��Ă��������B�x�N�g�����̎w��̂Ȃ����͂ɂ��ẮANaN �l�����͂�
% ��܂��B���i�̐����ɂ́A������1�̃f�[�^�������K�v�Ƃ���A���̃f�[�^
% �����́A�폜�A�܂��́A��s�� []�Ƃ��ďȗ�����܂��B�S�Ă̓��͂́A����
% �f�[�^�̃N���X�ɉ����āAFINARGPARSE �ɂ���ĉ��߂���܂��B�f�[�^�̃N��
% �X���Q�Ƃ���ɂ́A"[FieldList, ClassList] = instbond" �ƃ^�C�v���Ă���
% �����B�Ȃ��A���t�ɂ��ẮA�V���A�����t�ԍ��A�܂��́A���t������œ���
% ���Ă��������B
%
%   Strike     - �t���A���s�g����闘���B�\�i���ŕ\�L����܂��B
%   Settle     - �t���A�̌��ϓ����������t������A�܂��́A�V���A�����t��
%   Maturity   - �t���A�̖��������������t������A�܂��́A�V���A�����t�ԍ�
%   Reset      - �N�ɉ��񖞊����K��邩�A���̕p�x�������X�J���l
%   Basis      - ���͂��ꂽ�t�H���[�h�����c���[�𕪐͂���ۂɓK�p�����
%                �����J�E���g��������X�J���l
%   Principal  - �z�茳�{(���ڌ��{)
%
% �o��:
%   ISet       - ���i�̏W������Ȃ�ϐ��B���i�́A�^�C�v���ɕ��ނ���A��
%                �̂��ꂼ��̃^�C�v�ɂ��āA�݂��ɈقȂ�f�[�^�t�B�[��
%                �h��ݒ肷�邱�Ƃ��ł��܂��B�L�����ꂽ�f�[�^�t�B�[���h
%                �́A���i�̂��ꂼ��ɑΉ�����s�x�N�g���A�܂��́A������
%                �ƂȂ��Ă��܂��B�ϐ� ISet �Ɋւ���ڍׂɂ��ẮA
%                "help instget" �ƃ^�C�v���Ă��������B
% 
%   FieldList  - ���̏��i�^�C�v�ɓK�p�����f�[�^�t�B�[���h�̖��̂����X
%                �g�\�����镶����ō\������� NFIELDS �s1��̃Z���z��B
% 
%   ClassList  - �e�t�B�[���h�̃f�[�^�N���X���L�ڂ��镶���񂩂�Ȃ� 
%                NFIELDS�s1��̃Z���z��A�����ɁA�L�ڂ����f�[�^�N���X
%                �ɂ���āA�����̉��ߖ@�����肳��܂��B���͉\�Ȉ�����
%                'dble', 'date',  'char' �ł��B 
% 
%   TypeString - �ǉ�����鏤�i�̃^�C�v���w�肷�镶����ł��B
%                TypeString = 'floor'
%
% �Q�l : INSTBOND, INSTCAP, INSTSWAP, INSTADDFIELD, INSTDISP, 
%        INTENVPRICE, HJMPRICE.


%   Author(s): M. Reyes-Kattar 03/10/99
%   Copyright 1995-2002 The MathWorks, Inc. 
