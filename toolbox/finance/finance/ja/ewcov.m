% EWCOV   �w���d�ݕt����p���āA���v���n�񂩂玑�Y�����U���o��
%
% [VarMat, PDFlag] = ewcov(TimeSeriesMatrix, DecayFactor, ... 
% LookBackHorizon) �́ALookBackHorizon �Ŏw�肳�ꂽ���Ԃɑ΂��āA���Y
% ���v���n�񂩂狤���U�s����v�Z���܂��B
%
% ����: 
%           TimeSeriesMatrix : �������v�̊ϑ��l�ō\�������NumObs�s 
%                              NumAssets��̍s��ATimeSeriesMatrix �̍�
%                              ���̍s�́A�e�ϐ��̍ł��Â��ϑ��l�ō\����
%                              ��Ă���A����ȍ~�̍s�́A���ŋ߂̊ϑ�
%                              �l���Â����̂���V�������̂ւƂ������Ԃ�
%                              �܂܂�Ă��܂��B
%           DecayFactor      : �X�J���l, 0 < DecayFactor <= 1�B�ϑ��l��
%                              �����t�@�N�^ k �ɂ��d�ݕt�����Ȃ���܂��B
%                              �����ŁAk �͍ł��V�����ϑ��l����̎���
%                              �X�e�b�v�̐����w���Ă��܂��B�f�t�H���g�ł�
%                              DecayFactor =1 �ŁA����́A�ϓ����d���`
%                              �ړ����σ��f��(BIS)�������Ă��܂��B����
%                              �t�@�N�^���������Ȃ�΂Ȃ�قǁA�ŋ߂�
%                              �f�[�^���A��苭�������悤�ɂȂ�܂��B
%           LookBackHorizon  : �X�J���̐����B�����U�̌v�Z�ɗp������
%                              ���ԃX�e�b�v�̐��ł��B�f�t�H���g�ł́A
%                              NumObs�X�e�b�v�̎��n��S�̂ƂȂ��Ă��܂��B
%
%   �o��: 
%           VarMat           : ���肳�ꂽ NumAssets �s NumAssets ���
%                              �����U�s�񎑎Y���v�v���Z�X�̕W���΍��́A
%                              ���̒ʂ�ł��B
%                                STDVec = sqrt(diag(VarMat))
%                              ���֍s��́A���̒ʂ�ł��B
%                                CorrMat = VarMat./( STDVec*STDVec' )
%
%            PDFlag          : VarMat �����l�̏ꍇ�A0�ƂȂ�AVarMat ��
%                              ����l�łȂ��ꍇ�A1���o�͂���܂��B����
%                              �f�[�^�̂������ɂ��ẮA���肳�ꂽ
%                              �����U�s��͏k�d���܂��B���̂悤�ȏꍇ�A
%                              VarMat �͏o�͂��܂����APDFlag ��1�ɐݒ�
%                              ����܂��B
%
%  �Q�l : COV.


%   Author(s): J. Akao 03/17/1998
%   Copyright 1995-2002 The MathWorks, Inc.  
