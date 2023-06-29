clearvars; clc; close all;
format compact;

% 參數
N = 256;        % frame length
Nhalf = N/2;    % half the frame length
Ngroup = 8;     % group length
% 讀取音檔
[xin, fs] = audioread('ADSP_voice_ privacy_method2_test.wav');
xin = xin(:,1);
Lx = length(xin); % total length of the speech signal

%% 頻譜解碼
% 音檔分割
xbuffer = buffer(xin, N); % 將音檔以每256分割,附註buffer這函式會自動把未滿256的部分自動補零
% FFT
s = fft(xbuffer);
% 頻譜移位
s = [s((Nhalf+1):end, :); s(1:Nhalf, :)];
% IFFT
xbuffer = ifft(s);
% 將訊號還原
xoutFreq = reshape(xbuffer, [], 1);
%% 時域解碼
xbuffer = buffer(xoutFreq, N*Ngroup);
xbuffer = flipud(xbuffer);
xout = reshape(xbuffer, [], 1);

audiowrite('output_2.wav', xout, fs);
% sound(xout);