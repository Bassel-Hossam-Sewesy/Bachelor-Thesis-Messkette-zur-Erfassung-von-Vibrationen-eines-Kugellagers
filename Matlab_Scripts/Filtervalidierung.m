%% Einfacher Vergleich der Filterausgänge + PNG Export
clear; clc; close all;

% =========================
% Dateien
% =========================
files = { ...
    'Filter300Hz_4Ord.csv', ...
    'Filter500Hz_2Ord.csv', ...
    'Filter500Hz_4Ord.csv', ...
    'Filter500Hz_6Ord.csv', ...
    'Filter1000Hz_4Ord.csv'};

labels = { ...
    '300 Hz, 4. Ordnung', ...
    '500 Hz, 2. Ordnung', ...
    '500 Hz, 4. Ordnung', ...
    '500 Hz, 6. Ordnung', ...
    '1000 Hz, 4. Ordnung'};

% =========================
% Laden
% =========================
data = cell(length(files),1);

for k = 1:length(files)
    T = readmatrix(files{k});
    t = T(:,1);
    y = T(:,2);

    % doppelte Zeitpunkte entfernen
    [t, idx] = unique(t, 'stable');
    y = y(idx);

    fs = 1/mean(diff(t));

    data{k}.t = t;
    data{k}.y = y;
    data{k}.fs = fs;
    data{k}.label = labels{k};
end

%% =========================
% Plot 1: Grenzfrequenz
% =========================
idx_fc = [1 3 5];

figure('Color','w','Position',[100 100 1000 500]); hold on; grid on;
for i = idx_fc
    [f, Ydb] = simple_fft(data{i}.y, data{i}.fs);
    plot(f, Ydb, 'LineWidth', 1.5, 'DisplayName', data{i}.label);
end
xlabel('Frequenz [Hz]');
ylabel('Amplitude [dB rel.]');
title('Einfluss der Grenzfrequenz bei gleicher Filterordnung');
legend('show','Location','best');
xlim([0 3000]);

% speichern
exportgraphics(gcf, 'Einfluss_Grenzfrequenz.png', 'Resolution', 300);

%% =========================
% Plot 2: Filterordnung
% =========================
idx_ord = [2 3 4];

figure('Color','w','Position',[100 100 1000 500]); hold on; grid on;
for i = idx_ord
    [f, Ydb] = simple_fft(data{i}.y, data{i}.fs);
    plot(f, Ydb, 'LineWidth', 1.5, 'DisplayName', data{i}.label);
end
xlabel('Frequenz [Hz]');
ylabel('Amplitude [dB rel.]');
title('Einfluss der Filterordnung bei gleicher Grenzfrequenz');
legend('show','Location','best');
xlim([0 3000]);

% speichern
exportgraphics(gcf, 'Einfluss_Filterordnung.png', 'Resolution', 300);

%% =========================
% FFT Funktion
% =========================
function [f, Xdb] = simple_fft(x, fs)
    x = x(:) - mean(x);
    N = length(x);

    X = fft(x .* hann(N));
    X = X(1:floor(N/2)+1);

    f = (0:floor(N/2))' * fs / N;

    mag = abs(X);
    mag = mag / max(mag);
    Xdb = 20*log10(mag + 1e-12);
end