%% Zeitverläufe der Testbench für vier Fehlerfälle plotten
clear; clc; close all;

% ===== Dateinamen anpassen =====
files = { ...
    'acc_x_Healthy.csv', ...
    'acc_x_Racedefect_Inner.csv', ...
    'acc_x_Racedefect_Outer.csv', ...
    'acc_x_Balldefect.csv'};

titles_txt = { ...
    'Gesundes Lager', ...
    'Innenringfehler', ...
    'Außenringfehler', ...
    'Wälzkörperfehler'};

% ===== Bereich für Zoom wie im Artikel anpassen =====
t_min = 4.0;
t_max = 4.3;

figure('Name','Zeitverläufe der Testbench','NumberTitle','off');

for k = 1:4
    T = readmatrix(files{k});
    t = T(:,1);
    x = T(:,2);

    % optional: nur gültige Werte
    valid = isfinite(t) & isfinite(x);
    t = t(valid);
    x = x(valid);

    subplot(2,2,k);
    plot(t, x, 'LineWidth', 1.0);
    grid on;
    xlim([t_min t_max]);
    xlabel('Zeit [s]');
    ylabel('Beschleunigung');
    title(titles_txt{k});
end

sgtitle('Vergleich der simulierten Zeitsignale für verschiedene Fehlerfälle');