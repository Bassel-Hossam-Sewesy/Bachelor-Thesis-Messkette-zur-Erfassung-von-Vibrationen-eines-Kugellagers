block IEPE_WithChargeAmplifier_Block
  "IEPE accelerometer sensor model: acc_x -> v_out (bias + AC), incl. low-cut and resonance, no AA/ADC"
  import Modelica.Constants.pi;
  import Modelica.Constants.g_n;

  Modelica.Blocks.Interfaces.RealInput acc_x
    "Acceleration input [m/s2]"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
                          iconTransformation(extent={{-120,-20},{-80,20}})));

  Modelica.Blocks.Interfaces.RealOutput v_out
    "IEPE output voltage [V] (bias + AC)"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
                          iconTransformation(extent={{80,-20},{120,20}})));

  // Piezo/charge parameters
  parameter Real Sq = 3.10e-12/g_n "Charge sensitivity [C/(m/s2)]";
  parameter Modelica.Units.SI.Capacitance Cp = 1000e-12 "Piezo capacitance [F]";
  parameter Modelica.Units.SI.Resistance Rp = 1e12 "Leakage [Ohm]";
  parameter Modelica.Units.SI.Capacitance Cf = 100e-12 "Feedback capacitance [F]";
  parameter Modelica.Units.SI.Resistance  Rf = 1e9 "Feedback resistance [Ohm]";
  parameter Modelica.Units.SI.Voltage Vbias = 12 "IEPE bias voltage [V]";

  // === Frequency behavior (sensor-only, like datasheet description) ===
  parameter Modelica.Units.SI.Frequency f_hp = 0.5
    "Hz, low frequency cutoff from amplifier/IEPE chain (typically << 1 Hz)";
  parameter Modelica.Units.SI.Frequency f_res = 30000
    "Hz, sensor resonance (typ. 20..30 kHz for general purpose piezo accelerometers)";
  parameter Real zeta = 0.01 "Damping ratio (resonance sharpness)";

  final parameter Real w_hp = 2*pi*f_hp;
  final parameter Real w_n  = 2*pi*f_res;

  // High-pass: H(s) = s/(s + w_hp)
  Modelica.Blocks.Continuous.TransferFunction HP(b={1,0}, a={1,w_hp})
    annotation (Placement(transformation(extent={{-90,-70},{-70,-50}})));

  // Resonant 2nd order (DC gain 1): H(s)=wn^2/(s^2+2*zeta*wn*s+wn^2)
  Modelica.Blocks.Continuous.TransferFunction Res(b={w_n*w_n}, a={1,2*zeta*w_n,w_n*w_n})
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));

  // Internal (electrical) reference node
  Modelica.Electrical.Analog.Basic.Ground g
    annotation (Placement(transformation(extent={{-20,-100},{0,-80}})));

  // Piezo equivalent
  Modelica.Electrical.Analog.Basic.Capacitor Cpiezo(C=Cp)
    annotation (Placement(transformation(extent={{-70,10},{-50,30}})));
  Modelica.Electrical.Analog.Basic.Resistor Rleak(R=Rp)
    annotation (Placement(transformation(extent={{-70,-30},{-50,-10}})));
  Modelica.Electrical.Analog.Sources.SignalCurrent Ipiezo
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));

  // Charge amplifier core
  Modelica.Electrical.Analog.Ideal.IdealOpAmp3Pin op
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Modelica.Electrical.Analog.Basic.Capacitor Cfb(C=Cf)
    annotation (Placement(transformation(extent={{10,10},{30,30}})));
  Modelica.Electrical.Analog.Basic.Resistor Rfb(R=Rf)
    annotation (Placement(transformation(extent={{10,-30},{30,-10}})));

  // Biased output: V = Vbias + vconv
  Modelica.Electrical.Analog.Sources.SignalVoltage VoutSrc
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

  // Sense opamp output (vconv) relative to ground
  Modelica.Electrical.Analog.Sensors.VoltageSensor Vsense
    annotation (Placement(transformation(extent={{10,-70},{30,-50}})));

equation
  // --- sensor frequency shaping ---
  connect(HP.u, acc_x);
  connect(Res.u, HP.y);

  // Piezo: i = Sq * d/dt(acc_shaped)
  Ipiezo.i = Sq * der(Res.y);

  // Wire piezo network into opamp inverting node
  connect(Ipiezo.p, op.in_n);
  connect(Cpiezo.p, op.in_n);
  connect(Rleak.p, op.in_n);

  connect(Ipiezo.n, g.p);
  connect(Cpiezo.n, g.p);
  connect(Rleak.n, g.p);

  // Opamp non-inverting at ground
  connect(op.in_p, g.p);

  // Feedback Cf || Rf
  connect(Cfb.p, op.out);  connect(Cfb.n, op.in_n);
  connect(Rfb.p, op.out);  connect(Rfb.n, op.in_n);

  // Sense vconv and add bias
  connect(Vsense.p, op.out);
  connect(Vsense.n, g.p);

  VoutSrc.v = Vbias + Vsense.v;
  connect(VoutSrc.n, g.p);
  v_out = VoutSrc.p.v - g.p.v;

annotation (
  Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
  Diagram(coordinateSystem(extent={{-150,-120},{150,120}}))
);
end IEPE_WithChargeAmplifier_Block;
