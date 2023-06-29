clearvars; clc; close all;
format compact;

% 參數設置
fileName = 'Prob1_test1.wav';

% 讀取音檔
[S.data, S.fs] = audioread(fileName);

% 設置filter參數
filterPara.wp = [30, 90]/(S.fs/2);
filterPara.ws = [55, 65]/(S.fs/2);
filterPara.rp = 0.5;
filterPara.rs = 40;

S.dataFreq = abs(fft(S.data));
S.lengthHalf = floor(length(S.data)/2);
figure();   plot(linspace(0,4000,S.lengthHalf), S.dataFreq(1:S.lengthHalf));
axis([25, 95, -10, 200]);
% 設置filter
    % butterworth
[filterPara.N, filterPara.wc] = buttord(filterPara.wp, filterPara.ws, filterPara.rp, filterPara.rs);
[filterCoe.b, filterCoe.a] = butter(filterPara.N, filterPara.wc, 'stop');
	% Chebyshev-I
% [filterPara.N, filterPara.wc] = cheb1ord(filterPara.wp, filterPara.ws, filterPara.rp, filterPara.rs);
% [filterCoe.b, filterCoe.a] = cheby1(filterPara.N, filterPara.rp, filterPara.wc, 'stop');
% 	% Chebyshev-II
% [filterPara.N, filterPara.wc] = cheb2ord(filterPara.wp, filterPara.ws, filterPara.rp, filterPara.rs);
% [filterCoe.b, filterCoe.a] = cheby2(filterPara.N, filterPara.rs, filterPara.wc, 'stop');
% 	% Elliptic
% [filterPara.N, filterPara.wc] = ellipord(filterPara.wp, filterPara.ws, filterPara.rp, filterPara.rs);
% [filterCoe.b, filterCoe.a] = ellip(filterPara.N, filterPara.rp, filterPara.rs, filterPara.wc, 'stop');

% 顯示頻率響應圖
figure(); 
[h, f] = freqz(filterCoe.b, filterCoe.a, 4000, S.fs);  
subplot(2,1,1);  plot(f, abs(h));
axis([25, 95, -inf, inf]);
xlabel('Hz'); ylabel('Gain');
title('Bandstop Filter(60hz)');

subplot(2,1,2);  plot(f, 20*log10(abs(h))); grid; % mag resp. in the dB scale
axis([25, 95, -inf, inf]);
xlabel('Hz'); ylabel('Gain(dB)');
title('Bandstop Filter(60hz)');

% 將訊號進行濾波
S.dst = myfilter(filterCoe.b, filterCoe.a, S.data); % 自己寫的
% S.dst = filter(filterCoe.b, filterCoe.a, S.data);  % build-in

% 訊號正歸化
S.dst = S.dst / max(abs(S.dst));

%
S.dstFreq = abs(fft(S.dst));
figure();   plot(linspace(0,4000,S.lengthHalf), S.dstFreq(1:S.lengthHalf));
axis([25, 95, -10, 200]);

% 儲存檔案
audiowrite('result_1.wav', S.dst, S.fs);

% 播放聲音
% sound(S.dst);