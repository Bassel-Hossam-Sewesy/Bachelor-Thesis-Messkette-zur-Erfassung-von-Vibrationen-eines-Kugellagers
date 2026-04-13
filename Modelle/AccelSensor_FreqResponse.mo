model AccelSensor_FreqResponse
  import Modelica.Blocks.Continuous.TransferFunction;
  import Modelica.Constants.pi;

  parameter Real S = 1e-2 "Sensitivity [V/(m/s2)]";

  // optional mechanics
  //parameter Boolean useMech = true;
  parameter Real f_res = 30000 "Resonance frequency [Hz]";
  parameter Real zeta  = 0.01  "Damping ratio";

  parameter Real f_hp = 0.5    "High-pass cutoff [Hz]";
  parameter Real f_lp = 10000   "Low-pass cutoff [Hz], might be not necessary idk";

  Modelica.Blocks.Interfaces.RealInput  a_in annotation (Placement(
      visible=true,
      transformation(origin={-100,0}, extent={{-20,-20},{20,20}}, rotation=0),
      iconTransformation(origin={-100,0}, extent={{-20,-20},{20,20}}, rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput v_out annotation (Placement(
      visible=true,
      transformation(origin={100,0}, extent={{-20,-20},{20,20}}, rotation=0),
      iconTransformation(origin={100,0}, extent={{-20,-20},{20,20}}, rotation=0)));

protected
  final parameter Real w_n = 2*pi*f_res;
  final parameter Real tau_hp = 1/(2*pi*f_hp);
  final parameter Real tau_lp = 1/(2*pi*f_lp);

  // Conditional mechanical TF: exists only if useMech=true
  TransferFunction mechTF(
    b = {w_n^2},
    a = {1, 2*zeta*w_n, w_n^2});// if useMech;

  // Bypass path (only present when mechTF is NOT present)
  //Modelica.Blocks.Routing.RealPassThrough bypass if not useMech;

  TransferFunction gainTF(b = {S}, a = {1});

  TransferFunction hpTF(b = {tau_hp, 0}, a = {tau_hp, 1});
  TransferFunction lpTF(b = {1}, a = {tau_lp, 1});

equation
  // Either mech path...
  connect(a_in, mechTF.u);
  connect(mechTF.y, gainTF.u);

  // ...or bypass path
  //connect(a_in, bypass.u);
  // connect(bypass.y, gainTF.u);

  // common chain
  connect(gainTF.y, hpTF.u);
  connect(hpTF.y,   lpTF.u);
  connect(lpTF.y,   v_out);
end AccelSensor_FreqResponse;
