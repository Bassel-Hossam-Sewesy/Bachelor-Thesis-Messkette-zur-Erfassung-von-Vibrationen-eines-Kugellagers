%% Einfluss der Abtastrate auf die Hüllkurvenanalyse
clear; clc; close all;

% =========================
% Dateien
% =========================
files = { ...
    'Sampler300Hz.csv', ...
    'sampler5120Hz.csv', ...
    'sampler10240Hz.csv'};

labels = { ...
    '300 Hz', ...
    '5120 Hz', ...
    '10240 Hz'};

data = cell(length(files),1);

% =========================
% Laden
% =========================
for k = 1:length(files)

    T = readmatrix(files{k});

    t_raw = T(:,1);
    x_raw = T(:,2);

    % ==========================================
    % Sonderbehandlung für 300-Hz-Sampler
    % ==========================================
    if strcmp(labels{k}, '300 Hz')

        fs_target = 300;
        Ts = 1/fs_target;

        % Nur Punkte auf dem 300-Hz-Raster
        n = round(t_raw / Ts);

        idx_sample = abs(t_raw - n*Ts) < 1e-7;

        n_s = n(idx_sample);
        x_s = x_raw(idx_sample);

        % Für jeden Zeitpunkt letzten Wert nehmen
        [n_unique, ia] = unique(n_s, 'last');

        % sortieren
        [n_unique, order] = sort(n_unique);
        ia = ia(order);

        t = n_unique * Ts;
        x = x_s(ia);

        fs = fs_target;

    else

        % Normale Verarbeitung
        [t, idx] = unique(t_raw, 'stable');
        x = x_raw(idx);

        fs = 1/mean(diff(t));

    end

    data{k}.t = t(:);
    data{k}.x = x(:);
    data{k}.fs = fs;
    data{k}.label = labels{k};
    data{k}.fN = fs/2;

    fprintf('%s: fs = %.2f Hz | Nyquist = %.2f Hz | Samples = %d\n', ...
        labels{k}, data{k}.fs, data{k}.fN, length(data{k}.t));
end

%% =========================
% Hüllkurven-FFT berechnen
% =========================
for k = 1:length(data)

    x = data{k}.x(:);
    fs = data{k}.fs;

    % DC entfernen
    x = x - mean(x);

    % Hüllkurve
    env = abs(hilbert(x));

    % Mittelwert entfernen
    env = env - mean(env);

    % FFT
    [f_env, Edb] = simple_fft(env, fs);

    data{k}.f_env = f_env;
    data{k}.Edb = Edb;

end

%% =========================
% Plot 1: Subplots
% =========================
figure('Color','w','Position',[100 100 1000 800]);

for k = 1:length(data)

    subplot(3,1,k);
    hold on;
    grid on;

    plot(data{k}.f_env, data{k}.Edb, ...
        'k', 'LineWidth', 1.2);

    % Marker
    xline(17,    'g--', '1x',   'LineWidth',1.0);
    xline(34,    'g-',  '2x',   'LineWidth',1.0);
    xline(40.38, 'r--', 'BSF',  'LineWidth',1.0);
    xline(61.05, 'k--', 'BPFO', 'LineWidth',1.0);
    xline(91.95, 'b--', 'BPFI', 'LineWidth',1.0);

    % Nyquist
    xline(data{k}.fN, ...
        'm--', 'Nyquist', 'LineWidth',1.0);

    xlabel('Frequenz [Hz]');
    ylabel('Amplitude [dB rel.]');

    title(sprintf('Envelope-FFT bei Abtastrate %s', ...
        data{k}.label));

    % Plotbereich
    xlim([0 min(200, data{k}.fN)]);

    ylim([-80 5]);

end

sgtitle('Vergleich der Hüllkurvenspektren bei unterschiedlichen Abtastraten');

exportgraphics(gcf, ...
    'Envelope_Abtastrate_Subplots.png', ...
    'Resolution', 300);

%% =========================
% Plot 2: Gemeinsamer Vergleich
% =========================
figure('Color','w','Position',[100 100 1000 500]);

hold on;
grid on;

for k = 1:length(data)

    idx_plot = data{k}.f_env <= 150;

    plot(data{k}.f_env(idx_plot), ...
         data{k}.Edb(idx_plot), ...
         'LineWidth', 1.5, ...
         'DisplayName', data{k}.label);

end

% Marker
xline(17,    'g--', '1x',   'LineWidth',1.0);
xline(34,    'g-',  '2x',   'LineWidth',1.0);
xline(40.38, 'r--', 'BSF',  'LineWidth',1.0);
xline(61.05, 'k--', 'BPFO', 'LineWidth',1.0);
xline(91.95, 'b--', 'BPFI', 'LineWidth',1.0);

xlabel('Frequenz [Hz]');
ylabel('Amplitude [dB rel.]');

title('Einfluss der Abtastrate auf das Hüllkurvenspektrum (0 bis 150 Hz)');

legend('show','Location','best');

xlim([0 150]);
ylim([-80 5]);

exportgraphics(gcf, ...
    'Envelope_Abtastrate_150Hz.png', ...
    'Resolution', 300);

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

    mag = mag / max(mag + 1e-12);

    Xdb = 20*log10(mag + 1e-12);

end