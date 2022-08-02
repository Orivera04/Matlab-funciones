% INSTCAP   'Cap'�^�C�v ���i�̍쐬�֐�
%
% �f�[�^�z�񂩂�V�������i�ϐ��𐶐�����ɂ́A���̂悤�ɐݒ肵�܂��B
%   ISet = instcap(Strike, Settle, Maturity, Reset, Basis, Principal)
%
% 'Cap' ���i�����i�ϐ��ɒǉ�����ɂ́A���̂悤�ɐݒ肵�܂��B
%   ISet = instcap(ISet, Strike, Settle, Maturity, Reset, Basis, ....
%           Principal)
%
% 'Cap' ���i�ɓK�p�����t�B�[���h���^�f�[�^��\������ɂ́A���̂悤��
% �ݒ肵�܂��B
%   [FieldList, ClassList, TypeString] = instcap;
%
% ����: 
% �f�[�^�����ɂ́ANINST �s1��̃x�N�g���A�X�J���A�܂��́A��̂����ꂩ��
% ���͂ł��܂��B�x�N�g�����̎w��̂Ȃ����͂ɂ��ẮANaN �l�����͂����
% ���B���i�̐����ɂ͂�����1�̃f�[�^�������K�v�Ƃ���A���̃f�[�^������
% �폜�A�܂��́A��s�� []�Ƃ��ďȗ�����܂��B�S�Ă̓��͂́A���̓f�[�^��
% �N���X�ɉ����āAFINARGPARSE �ɂ���ĉ��߂���܂��B�f�[�^�̃N���X���Q��
% ����ɂ́A"[FieldList, ClassList] = instcap" �ƃ^�C�v���Ă��������B
% �Ȃ��A���t�ɂ��ẮA�V���A�����t�ԍ��A�܂��́A���t������œ��͂���
% ���������B
%
%   Strike     - �L���b�v���s�g����闘���B�\�i�@�ŕ\�L����܂��B
%   Settle     - �L���b�v�̌��ϓ����������t������A�܂��́A�V���A�����t
%                �ԍ��B
%   Maturity   - �L���b�v�̖��������������t������A�܂��́A�V���A�����t
%                �ԍ��B
%   Reset      - �N�ɉ��񖞊����K��邩�A���̕p�x�������X�J���l�B
%   Basis      - ���͂��ꂽ�t�H���[�h�����c���[�̕��͂ɗp��������t
%                �J�E���g��������X�J���l�B
%   Principal  - �z�茳�{(���ڌ��{)�B
%
% �o��:
%   ISet       - ���i�̏W������Ȃ�ϐ��B���i�́A�^�C�v���ɕ��ނ���A��
%                �̂��ꂼ��̃^�C�v�ɂ��āA�݂��ɈقȂ�f�[�^�t�B�[��
%                �h��ݒ肷�邱�Ƃ��ł��܂��B�L�����ꂽ�f�[�^�t�B�[���h
%                �́A���i�̂��ꂼ��ɑΉ�����s�x�N�g���A�܂��́A������
%                �ƂȂ��Ă��܂��B�ϐ� ISet �Ɋւ���ڍׂɂ��ẮA
%                "help instget" �ƃ^�C�v���Ă��������B
%   FieldList  - ���̏��i�^�C�v�ɓK�p�����f�[�^�t�B�[���h�̖��̂����X
%                �g�\�����镶����ō\������� NFIELDS �s1��̃Z���z��B
%   ClassList  - �e�t�B�[���h�̃f�[�^�N���X���L�ڂ��镶���񂩂�Ȃ� 
%                NF-IELDS�s1��̃Z���z��A�����ɋL�ڂ����f�[�^�N���X��
%                ����āA�����̉��ߖ@�����肳��܂��B���͉\�Ȉ����́A
%                'dble', 'date',  'char' �ł��B 
%   TypeString - �ǉ�����鏤�i�̃^�C�v���w�肷�镶����ł��B
%                 TypeString = 'Cap'
%
% �Q�l : INSTBOND, INSTFLOOR, INSTSWAP, INSTADDFIELD, INSTDISP, 
%        INTENVPRICE, HJMPRICE.


%   Author(s): M. Reyes-Kattar 03/10/99
%   Copyright 1995-2002 The MathWorks, Inc. 
