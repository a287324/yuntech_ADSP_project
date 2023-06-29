clearvars; clc; close all;
format compact;

% 參數
N = 256; % frame length
Nhalf = N/2; % half the frame length

% 讀取音檔
[xin, fs] = audioread('ADSP_voice_ privacy_method1_test.wav');
xin = xin(:,1);
Lx = length(xin); % total length of the speech signal

% 音檔長度補長至256的倍數
FN = ceil(Lx/N);        % number of frames
nz = N * FN - Lx;       % number of zeros to be appended to the last frame
xin = [xin; zeros(nz,1)];   % the augmented input with padded zeros
xout = zeros(Lx + nz, 1);   % x_out is the descrambled signal

% 音檔解密
for k=1:FN
    % 從時域取出一個frame
    xseg = xin((k-1)*N+1 : k*N);
    % 取出的片段轉頻域(fft)
    s = fft(xseg);
    % 頻域移位
    s = [s((Nhalf+1):end);s(1:Nhalf)];
    % 反轉換
    xout((k-1)*N+1 : k*N) = ifft(s);
end
% audiowrite('output_1.wav', xout, fs);
sound(xout);