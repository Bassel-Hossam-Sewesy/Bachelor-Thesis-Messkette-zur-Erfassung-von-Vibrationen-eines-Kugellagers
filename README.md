# Bachelor-Thesis: Messkette zur Erfassung von Vibrationen eines Kugellagers

Dieses Repository enthält die Ergebnisse der Bachelorarbeit von **Bassel Hossam Sewesy**.

## Titel der Arbeit
**„Modellierung und Simulation einer Messkette zur Erfassung der Vibrationen eines Kugellagers für Diagnosezwecke“**

---

## Ziel der Arbeit

Ziel dieser Arbeit ist die Modellierung und Analyse einer vibrationsbasierten Messkette zur Zustandsüberwachung von Wälzlagern.  
Dabei wird untersucht, wie sich verschiedene Komponenten der Messkette auf die Detektion charakteristischer Fehlerfrequenzen auswirken.

Im Fokus stehen insbesondere:

- Modellierung eines piezoelektrischen Beschleunigungssensors (IEPE)
- Einfluss des Anti-Aliasing-Filters
- Einfluss der Abtastrate
- Analyse im Zeit- und Frequenzbereich
- Anwendung der Hüllkurvenanalyse zur Fehlerdetektion

---

## Aufbau der Messkette

Die modellierte Messkette besteht aus folgenden Komponenten:

1. **Mechanisches Signal**
   - Beschleunigungssignal aus einer Testbench (OpenModelica)

2. **Beschleunigungssensor**
   - Piezoelektrisches Modell mit:
     - Hochpassverhalten
     - Resonanz
     - Ladungsverstärker

3. **Signalaufbereitung**
   - Verstärkung und Bias

4. **Anti-Aliasing-Filter**
   - Butterworth-Tiefpass
   - Variation von:
     - Grenzfrequenz
     - Filterordnung

5. **Abtastung**
   - Diskretisierung mit verschiedenen Abtastraten

6. **Signalverarbeitung** (NICHT TEIL DER MESSKETTE, wurde in Matlab vorgenommen)
   - Fourier-Analyse (FFT)
   - Hüllkurvenanalyse (Envelope)

---

## Inhalte des Repositories

Das Repository enthält:

- **Modelica-Modelle**
  - Implementierung der Messkette
  - Sensor-Modell (IEPE)

- **MATLAB-Skripte**
  - FFT-Analyse
  - Hüllkurvenanalyse
  - Vergleich von:
    - Filterparametern
    - Abtastraten

- **Simulationsdaten**
   - Zeitreihen der Beschleunigungssignale
   - Gefilterte und abgetastete Signale

- **Plots**
  - Frequenzspektren
  - Hüllkurvenspektren
  - Bode-Diagramme


## Zentrale Erkenntnisse

- Die reine Fourier-Analyse des Rohsignals ist für die Detektion von Lagerfehlern nur eingeschränkt geeignet.
- Die Hüllkurvenanalyse ermöglicht die klare Identifikation charakteristischer Fehlerfrequenzen (BPFO, BPFI, BSF).
- Die Abtastrate hat einen entscheidenden Einfluss auf die Qualität der Fehlerdetektion.
- Das Anti-Aliasing-Filter stellt einen Trade-off zwischen Signalqualität und Aliasingschutz dar.
- Die gesamte Messkette muss als System betrachtet werden, da alle Komponenten das Ergebnis beeinflussen.

---

## Nutzung der Modelle
- Modelle sind im Ordner namens "Modelle" zu finden
- Modell "Messketteadvanced" und alle eingebundenen Libraries öffnen
- Parameter nach belieben anpassen und Simulationen laufen lassen
- Auswahl des Zustands des Wälzlagers:
  1. BearingLibrary öffnen und den Teststand namens "VirtualBench_layout_v1" auswählen.
  2. Komponente "Test Bearing" doppelklicken
  3. Defect Type auswählen (Zur Auswahl stehen Raceway defect, Balldefect und Healthy)
  3.1 Für Raceway defect weiter auf Defect properties und {1} für outer oder {2} für inner defect auswählen

## Hinweise

- Alle Ergebnisse basieren auf **Simulationen**.
- Reale Einflüsse wie Rauschen, Temperatur oder Nichtlinearitäten sind nicht vollständig berücksichtigt.
- Eine Validierung mit realen Messdaten wird als zukünftige Arbeit empfohlen.
- OpenModelica Version: OpenModelica v1.25.4 (64-bit)
- Bei Verwendung der Modelle oder der Arbeit als Quelle bitte Autor mit angeben

---

## Autor

**Bassel Hossam Sewesy**  
Bachelorstudiengang : Technische Informatik 
Masterstudiengang   : Computer Engineering  
Technische Universität Berlin

---

## Kontakt

Bei Fragen zu diesem Repository oder der Arbeit gerne melden.
