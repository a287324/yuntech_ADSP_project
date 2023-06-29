clearvars; clc; close all;
format compact;

% 參數
N = 256; % frame length
Nhalf = N/2; % half the frame length

% 讀取音檔
[xin, fs] = audioread('ADSP_voice_ privacy_method1_test.wav');
xin = xin(:,1);
Lx = length(xin); % total length of the speech signal

% 音檔分割
xbuffer = buffer(xin, N); % 將音檔以每256分割,附註buffer這函式會自動把未滿256的部分自動補零
% FFT
s = fft(xbuffer);
% 頻譜移位
s = [s((Nhalf+1):end, :); s(1:Nhalf, :)];
% IFFT
xbuffer = ifft(s);
% 將訊號還原
xout = reshape(xbuffer, [], 1);
% 儲存解密訊號
audiowrite('output_2.wav', xout, fs);
% 播放訊號
sound(xout);