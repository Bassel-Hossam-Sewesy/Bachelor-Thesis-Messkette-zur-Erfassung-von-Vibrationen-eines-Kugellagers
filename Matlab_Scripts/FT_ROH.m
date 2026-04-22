clear; clc; close all;

% =========================
% Daten laden
% =========================
T = readmatrix("20s_const_sensor_blue_20db.csv");
t = T(:,1);
x = T(:,2);

x = x - mean(x);

% Samplingrate
dt = mean(diff(t));
fs = 1/dt;

% =========================
% FFT
% =========================
N = length(x);
w = hann(N);
X = fft(x .* w);

f = (0:N-1)*(fs/N);
X_mag = abs(X)/N;

% nur halbes Spektrum
f = f(1:N/2);
X_mag = X_mag(1:N/2);

% =========================
% Plot
% =========================
figure('Color','w','Position',[100 100 900 600]);
% ---- Zeitbereich ----
subplot(2,1,1)
plot(t, x, 'k')
xlabel('Zeit [s]')
ylabel('Amplitude')
title('Rohsignal (20dB)')
grid on

% ---- Frequenzbereich ----
subplot(2,1,2)
plot(f, X_mag, 'k')
xlabel('Frequenz [Hz]')
ylabel('Amplitude')
title('Frequenzspektrum (FFT) (20dB)')
grid on
xlim([0 100]) 

% =========================
% speichern
% =========================
exportgraphics(gcf, 'Signal_und_FFT_20DB.png', 'Resolution', 300);