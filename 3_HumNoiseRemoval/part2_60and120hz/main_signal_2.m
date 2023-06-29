clearvars; clc; close all;
format compact;

% 參數設置
fileName = 'Prob1_test2.wav';

% 讀取音檔
[S.data, S.fs] = audioread(fileName);

% 設置filter參數
    % 60hz
filterPara60Hz.wp = [30, 90]/(S.fs/2);
filterPara60Hz.ws = [55, 65]/(S.fs/2);
filterPara60Hz.rp = 0.5;
filterPara60Hz.rs = 40;
    % 120hz
filterPara120Hz.wp = [90, 150]/(S.fs/2);
filterPara120Hz.ws = [115, 125]/(S.fs/2);
filterPara120Hz.rp = 0.5;
filterPara120Hz.rs = 40;


% 設置filter
    % butterworth
[filterPara60Hz.N, filterPara60Hz.wc] = buttord(filterPara60Hz.wp, filterPara60Hz.ws, filterPara60Hz.rp, filterPara60Hz.rs);
[filterCoe_60hz.b, filterCoe_60hz.a] = butter(filterPara60Hz.N, filterPara60Hz.wc, 'stop');  % b is the numerator, and a is the denominator
[filterPara120Hz.N, filterPara120Hz.wc] = buttord(filterPara120Hz.wp, filterPara120Hz.ws, filterPara120Hz.rp, filterPara120Hz.rs);
[filterCoe_120hz.b, filterCoe_120hz.a] = butter(filterPara120Hz.N, filterPara120Hz.wc, 'stop');  % b is the numerator, and a is the denominator
% 	% Chebyshev-I
% [filterPara60Hz.N, filterPara60Hz.wc] = cheb1ord(filterPara60Hz.wp, filterPara60Hz.ws, filterPara60Hz.rp, filterPara60Hz.rs);
% [filterCoe_60hz.b, filterCoe_60hz.a] = cheby1(filterPara60Hz.N, filterPara60Hz.rp, filterPara60Hz.wc, 'stop');
% [filterPara120Hz.N, filterPara120Hz.wc] = cheb1ord(filterPara120Hz.wp, filterPara120Hz.ws, filterPara120Hz.rp, filterPara120Hz.rs);
% [filterCoe_120hz.b, filterCoe_120hz.a] = cheby1(filterPara120Hz.N, filterPara120Hz.rp, filterPara120Hz.wc, 'stop');
% 	% Chebyshev-II
% [filterPara60Hz.N, filterPara60Hz.wc] = cheb2ord(filterPara60Hz.wp, filterPara60Hz.ws, filterPara60Hz.rp, filterPara60Hz.rs);
% [filterCoe_60hz.b, filterCoe_60hz.a] = cheby2(filterPara60Hz.N, filterPara60Hz.rs, filterPara60Hz.wc, 'stop');
% [filterPara120Hz.N, filterPara120Hz.wc] = cheb2ord(filterPara120Hz.wp, filterPara120Hz.ws, filterPara120Hz.rp, filterPara120Hz.rs);
% [filterCoe_120hz.b, filterCoe_120hz.a] = cheby2(filterPara120Hz.N, filterPara120Hz.rs, filterPara120Hz.wc, 'stop');
% 	% Elliptic
% [filterPara60Hz.N, filterPara60Hz.wc] = ellipord(filterPara60Hz.wp, filterPara60Hz.ws, filterPara60Hz.rp, filterPara60Hz.rs);
% [filterCoe_60hz.b, filterCoe_60hz.a] = ellip(filterPara60Hz.N, filterPara60Hz.rp, filterPara60Hz.rs, filterPara60Hz.wc, 'stop');
% [filterPara120Hz.N, filterPara120Hz.wc] = ellipord(filterPara120Hz.wp, filterPara120Hz.ws, filterPara120Hz.rp, filterPara120Hz.rs);
% [filterCoe_120hz.b, filterCoe_120hz.a] = ellip(filterPara120Hz.N, filterPara120Hz.rp, filterPara120Hz.rs, filterPara120Hz.wc, 'stop');

% 顯示頻率響應圖
figure();
	% 60hz
[h, f] = freqz(filterCoe_60hz.b, filterCoe_60hz.a, 8000, S.fs); 
subplot(2,2,1);  plot(f, abs(h));
axis([25, 95, -inf, inf]);
xlabel('Hz'); ylabel('Gain');
title('Bandpass Filter(60hz)');

subplot(2,2,2);  plot(f, 20*log10(abs(h))); grid; % mag resp. in the dB scale
axis([25, 95, -inf, inf]);
xlabel('Hz'); ylabel('Gain(dB)');
title('Bandpass Filter(60hz)');
	% 120hz
[h, f] = freqz(filterCoe_120hz.b, filterCoe_120hz.a, 8000, S.fs);   
subplot(2,2,3);  plot(f, abs(h));
axis([85, 155, -inf, inf]);
xlabel('Hz'); ylabel('Gain');
title('Bandstop Filter(120hz)');

subplot(2,2,4);  plot(f, 20*log10(abs(h))); grid; % mag resp. in the dB scale
axis([85, 155, -inf, inf]);
xlabel('Hz'); ylabel('Gain(dB)');
title('Bandstop Filter(120hz)');

% 將訊號進行濾波(自己寫的)
S.dst = myfilter(filterCoe_60hz.b, filterCoe_60hz.a, S.data);
S.dst = myfilter(filterCoe_120hz.b, filterCoe_120hz.a, S.dst);
% S.dst = filter(filterCoe_60hz.b, filterCoe_60hz.a, S.data);   % built-in
% S.dst = filter(filterCoe_120hz.b, filterCoe_120hz.a, S.dst);

% 訊號正歸化
S.dst = S.dst / max(abs(S.dst));

% 儲存檔案
audiowrite('result_2.wav', S.dst, S.fs);

% 播放聲音
% sound(S.dst);