%% Daten laden
dataHealty = readmatrix("Healthydatasampled.csv");
dataBalldefect = readmatrix("BalldefectSampled.csv");
dataRacedefectInner = readmatrix("RacedefectInnerSampled.csv");
dataRacedefectOuter = readmatrix("RacedefectOuterSampled.csv");

% Nur die 2. Spalte verwenden (erste Spalte = Abtastwerte)
x1 = dataHealty(:, 2);
x2 = dataBalldefect(:, 2);
x3 = dataRacedefectInner(:, 2);
x4 = dataRacedefectOuter(:, 2);

% Zeitvektor aus erster Spalte (optional)
t1 = dataHealty(:, 1);
t2 = dataBalldefect(:, 1);
t3 = dataRacedefectInner(:, 1);
t4 = dataRacedefectOuter(:, 1);

% Envelope berechnen
[up1, lo1] = envelope(x1, 25600, 'peak');
[up2, lo2] = envelope(x2, 25600, 'peak');
[up3, lo3] = envelope(x3, 25600, 'peak');
[up4, lo4] = envelope(x4, 25600, 'peak');

%% Healthy - Plot
figure;
hold on
%plot(t1, x1, 'linewidth', 1.5, 'DisplayName', 'Signal')
plot(t1, up1, 'linewidth', 1.5, 'DisplayName', 'Obere Hüllkurve')
plot(t1, lo1, 'linewidth', 1.5, 'DisplayName', 'Untere Hüllkurve')
legend('show')
xlabel('Zeit / Abtastwerte')
ylabel('Amplitude')
title('Healthy Bearing')
grid on
hold off

%% Balldefect - Plot
figure;
hold on
%plot(t2, x2, 'linewidth', 1.5, 'DisplayName', 'Signal')
plot(t2, up2, 'linewidth', 1.5, 'DisplayName', 'Obere Hüllkurve')
plot(t2, lo2, 'linewidth', 1.5, 'DisplayName', 'Untere Hüllkurve')
legend('show')
xlabel('Zeit / Abtastwerte')
ylabel('Amplitude')
title('Ball Defect')
grid on
hold off

%% RacedefectInner - Plot
figure;
hold on
%plot(t3, x3, 'linewidth', 1.5, 'DisplayName', 'Signal')
plot(t3, up3, 'linewidth', 1.5, 'DisplayName', 'Obere Hüllkurve')
plot(t3, lo3, 'linewidth', 1.5, 'DisplayName', 'Untere Hüllkurve')
legend('show')
xlabel('Zeit / Abtastwerte')
ylabel('Amplitude')
title('Race Defect Inner')
grid on
hold off

%% RacedefectOuter - Plot
figure;
hold on
%plot(t4, x4, 'linewidth', 1.5, 'DisplayName', 'Signal')
plot(t4, up4, 'linewidth', 1.5, 'DisplayName', 'Obere Hüllkurve')
plot(t4, lo4, 'linewidth', 1.5, 'DisplayName', 'Untere Hüllkurve')
legend('show')
xlabel('Zeit / Abtastwerte')
ylabel('Amplitude')
title('Race Defect Outer')
grid on
hold off

%% Vergleich aller Hüllkurven
figure;
hold on
plot(t1, up1, 'linewidth', 1.5, 'DisplayName', 'Healthy')
plot(t2, up2, 'linewidth', 1.5, 'DisplayName', 'Ball Defect')
plot(t3, up3, 'linewidth', 1.5, 'DisplayName', 'Inner Race Defect')
plot(t4, up4, 'linewidth', 1.5, 'DisplayName', 'Outer Race Defect')
legend('show')
xlabel('Zeit / Abtastwerte')
ylabel('Amplitude')
title('Vergleich der oberen Hüllkurven')
grid on
hold off
