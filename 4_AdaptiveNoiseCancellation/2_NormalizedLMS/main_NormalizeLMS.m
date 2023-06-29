clearvars; clc; close all;

s = struct;
sn = struct;

% 參數設置
fileNameSignal = 'signal_with_noise_ex1.wav';
fileNameNoise = 'reference_noise_ex1.wav';
p = 10;         % filter order
beta = 0.05;    % step size
epsilon = 2;


% 讀取訊號
[x.data, x.fs] = audioread(fileNameSignal);
[n.data, n.fs] = audioread(fileNameNoise);

% 濾波器
w = zeros(p, 1);    % 濾波器初始值
wList = zeros(size(x.data,1), p); % 紀錄濾波器係數變化

% 模型訓練
nReg = [zeros(p-1,1); n.data];
e = zeros(size(x.data,1),1);
for it = 1:size(x.data,1)
    reg = nReg((it+p-1):-1:it);
    y = dot(w, reg);
    e(it) = x.data(it)-y;
    w = w + beta.*e(it).*reg./(epsilon+norm(reg).^2);
    wList(it,:) = w';
end

% 繪製濾波器係數變化圖
figure();  plot(wList);  title('filter coefficient');

% 執行模型
y = filter(w,1,n.data);
z = x.data-y(1:size(x.data,1));

% 儲存音檔
audiowrite('result_NormalizedLMS.wav', z, x.fs);

% 播放音檔
sound(z)
