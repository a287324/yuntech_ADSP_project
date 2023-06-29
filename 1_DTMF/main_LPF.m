clearvars; close all; clc;
format compact;
% DTMF Test Signal1 (Noisy)
% DTMF Test Signal2 (Noisy)

% 參數
InFile = 'src\ADSP_DTMF Test Signal2 (Noisy).wav';	%輸入音訊
fLowDTMFConst = [697 770 852 941].';
fHighDTMFConst = [1209 1336 1477 1633].';
windowSize = 25;     % window size of LPF
T = 0.05;               % threshold

% 讀取音訊
[s, fs] = audioread(InFile);

% 顯示音訊的時域
fpTime = figure();   
figure(fpTime);     subplot(4,1,1); plot(s);    title('音訊時域圖');

% 設置LPF(Moving-Average filter)
b = (1/windowSize)*ones(1,windowSize);
a = 1;

% 將訊號進行LPF(降躁.平滑化)
sAbs = abs(s);
figure(fpTime);     subplot(4,1,2); plot(sAbs);    title('abs(音訊)');
sLPF = filter(b,a,sAbs);    % y(n) = x(n) + x(n-1) + ...
figure(fpTime);     subplot(4,1,3); plot(sLPF);    title('LPF(abs(音訊))');

% 確認按鍵聲位置
sBin = (sLPF > T);  % 將訊號二值化
figure(fpTime);   subplot(4,1,4);   plot(sBin);   title('二值化');  
sLoc = sBin - circshift(sBin, 1);       % 訊號 - 將訊號經過右移的訊號
sIndBeg = find(sLoc == 1);
sIndEnd = find(sLoc == -1);
Len = length(sIndBeg);                  % 訊號總數

% 初始化按鍵列表
output = NaN(Len, 1);

% 解析各個按鍵聲
fpFreq = figure();
for m = 1:Len
	% 取出按鍵聲
    x = s(sIndBeg(m) : sIndEnd(m));
    % 按鍵聲音的長度
    N = sIndEnd(m) - sIndBeg(m) + 1;
    % 頻譜單位長度代表的頻率
    funit = fs/N;   % 頻譜每一格所代表的頻率
    fLowDTMF = fLowDTMFConst ./ funit + 1;     % +1是因為matlab變數的index起始是1所以要+1
    fHighDTMF = fHighDTMFConst ./ funit + 1;
    % FFT
    Fs1 = fft(x);
    MFs1 = abs(Fs1(1:floor(N/2)));  % 計算振幅頻譜，另外因為頻譜對稱，所以取一半就好
    % 取出頻譜最高頻和第二高頻
    [~, ind] = maxk(MFs1(1:(floor(N/2))), 2);   % 只取頻譜的一半來分析就可以，因為頻譜對稱
    ind = sort(ind);
    % 找出與DTMF最接近的頻率
    fLow = abs(ind(1) -  fLowDTMF);
    fHigh = abs(ind(2) - fHighDTMF);
    [~, indLow] = min(fLow);
    [~, indHigh] = min(fHigh);
    % 判斷數字
    num = nan;
    if indLow == 1 && indHigh == 1
        num = 1;
    elseif indLow == 1 && indHigh == 2
        num = 2;
    elseif indLow == 1 && indHigh == 3
        num = 3;
    elseif indLow == 2 && indHigh == 1
        num = 4;
    elseif indLow == 2 && indHigh == 2
        num = 5;
    elseif indLow == 2 && indHigh == 3
        num = 6;
    elseif indLow == 3 && indHigh == 1
        num = 7;
    elseif indLow == 3 && indHigh == 2
        num = 8;
    elseif indLow == 3 && indHigh == 3
        num = 9;
    elseif indLow == 4 && indHigh == 2
        num = 0;
    else
        error("分析出非數字訊號");
    end
    % 儲存結果
    output(m) = num;
    % 顯示結果
    figure(fpFreq); subplot(Len, 1, m);	plot(linspace(0, fs/2, length(MFs1)), MFs1); title(num2str(num));
    fprintf("第%d個按鍵聲為: %d\n", m, output(m));
end
