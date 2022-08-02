% EWSTATS   ���v���n�񂩂���Ҏ��v�y�ы����U���o��
%
% �I�v�V�����̎w���d�ݕt���́A���ŋ߂̃f�[�^���������܂��B
% 
%   [ExpReturn, ExpCovariance, NumEffObs] = ewstats(RetSeries, ...
%                                           DecayFactor, WindowLength)
%  
% ����:
%    RetSeries      : �ϓ��ɊԊu�����������v�̊ϑ��l�ō\������� 
%                     NUMOBS�sNASSETS��̍s��ł��B���̍s��̍ŏ��̍s��
%                     �ł��Â��ϑ��l�ƂȂ��Ă���A�Ō�̍s���ŐV�̊ϑ��l
%                     �ƂȂ��Ă��܂��B
%    DecayFactor    : ���ꂼ��̊ϑ��l�ɂ��āA�������̊ϑ��l���
%                     �ǂꂾ���d�ݕt�����y�����邩���R���g���[���������
%                     �ł��B���ԓI�ɂ����̂ڂ��� k �Ԗڂ̊ϑ��l�ɂ́A����
%                     �t�@�N�^ k �̏d�ݕt�����Ȃ���܂��B�����t�@�N�^��
%                     ���̒l��͈͓̔��łȂ���΂Ȃ�܂���B: 
%                     0 < DecayFactor <=1�A�f�t�H���g�́ADecayFactor = 1
%                     �ŁA����͋ϓ����d���`�ړ����σ��f��(BIS)�Ɠ���
%                     �ł��B
%    WindowLength   : �v�Z�Ɏg�p�����ŋ߂̊ϑ��l�̐��B�f�t�H���g�ł́A
%                     �S�Ă� NUMOBS �ϑ��l���ΏۂƂȂ�܂��B
%
% �o��:
%    ExpReturn      : ������Ҏ��v������1�sNASSETS��̍s��
%    ExpCovariance  : NASSETS�sNASSETS��̐��苤���U�s��
%    NumEffObs      : ���̌����ɂ���ė^������L���ϑ��l�̐��B
% 
%       NumEffObs = (1-DecayFactor^WindowLength)/(1-DecayFactor)
% 
%   DecayFactors�A�܂��́AWindowLengths �̒l���������Ȃ�قǁA���ŋ�
%   �̃f�[�^���������������悤�ɂȂ�܂����A���p�\�ȃf�[�^�Z�b�g��
%   ���͂�菭�Ȃ��Ȃ�ł��傤�B 
%
% ���Y���v�v���Z�X�̕W���΍��́A���̎��ɂ���ė^�����܂��B
% 
%     STDVec = sqrt(diag(ECov))
%
% �Ȃ��A���֍s��́A���̂Ƃ���ł��B
% 
%     CorrMat = VarMat./( STDVec*STDVec' )
%
% �Q�l : MEAN, COV, COV2CORR.


%   Author(s): J. Akao 3/16/98
%   Copyright 1995-2002 The MathWorks, Inc. 
