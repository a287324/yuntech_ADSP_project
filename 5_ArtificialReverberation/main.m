clearvars; clc; close all;
format compact;


%% alpas
[x,fs] = audioread('test.wav');
y = alpas(x,8000,0.5);
sound(y,fs);

%% reverb
% a = [0.6 0.4 0.2 0.1 0.7 0.6 0.8];
% R = [700 900 600 400 450 390];
% [x,fs] = audioread('test.wav');
% y = reverb(x,R,a);
% sound(y,fs);

%% multiecho
% [x,fs] = audioread('test.wav');
% y = multiecho(x,8000,0.5,3);
% sound(y);