clear; clc; close all;

% =========================
% Einstellungen
% =========================
file = "20s_const_sensor_blue_0db-1.csv";
gainLabel = "20 dB";
outFile = "Signal_und_FFT_0DB_dB.png";

% =========================
% Daten laden
% =========================
T = readmatrix(file);
t = T(:,1);
x = T(:,2);

% doppelte Zeitpunkte entfernen
[t, idx] = unique(t, 'stable');
x = x(idx);

% Mittelwert entfernen
x = x - mean(x);

% Samplingrate
fs = 1/mean(diff(t));

% =========================
% FFT
% =========================
N = length(x);
w = hann(N);

X = fft(x .* w);

% Einseitiges Amplitudenspektrum mit Fenster-Normierung
P2 = abs(X) / sum(w);
P1 = P2(1:floor(N/2)+1);
P1(2:end-1) = 2*P1(2:end-1);

f = (0:floor(N/2))' * fs / N;

% dB relativ zum Maximum
P1_dB = 20*log10(P1 / max(P1 + 1e-12) + 1e-12);

% =========================
% Plot
% =========================
figure('Color','w','Position',[100 100 900 650]);

subplot(2,1,1)
plot(t, x, 'k')
xlabel('Zeit [s]')
ylabel('Amplitude [rel.]')
title("Rohsignal (0dB)")
grid on

subplot(2,1,2)
plot(f, P1_dB, 'k', 'LineWidth', 1.2)
xlabel('Frequenz [Hz]')
ylabel('Amplitude [dB rel.]')
title("Frequenzspektrum (FFT) (0dB)")
grid on
xlim([0 100])
ylim([-100 5])

exportgraphics(gcf, outFile, 'Resolution', 300);