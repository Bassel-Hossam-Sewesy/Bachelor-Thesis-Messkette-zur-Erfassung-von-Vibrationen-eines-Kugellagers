model BearingHealty
  import Modelica.Constants.pi;
  type Stiffness = Real(final quantity="Stiffness", final unit="N/m", displayUnit="N/m");
  parameter Real n = 0;
  parameter Integer nb = 9 "number of balls";
  parameter Modelica.Units.SI.Diameter Db = 7.94e-3 "ball diameter";
  parameter Modelica.Units.SI.Diameter Dp = 39.32e-3 "pitch diameter";
  parameter Modelica.Units.SI.Angle PhiSlip = 0.01 "slip angle";
  parameter Real mut = 0 "mutation percentage";
  parameter Stiffness Kb = 1.89e10 "N/m stiffness of balls";
  parameter Modelica.Units.SI.Distance c = 1e-5 "m, bearing clearance";
  
  Modelica.Units.SI.AngularFrequency ws"shaft frequency";
  Modelica.Units.SI.AngularFrequency wc "cage angular frequency";
  Real ThetaChange;
  Modelica.Units.SI.Angle ThetaRaw[nb] "Angualar position of balls without slip";
  Modelica.Units.SI.Angle Theta[nb] "Angualar position of balls";
  Real loadzone[nb]; 
  Real DeltaRaw[nb];
  Real Delta[nb];
  Modelica.Units.SI.Force force_x[nb](start=zeros(nb));
  Modelica.Units.SI.Force force_y[nb](start=zeros(nb));
  Modelica.Units.SI.Force Fx=0;
  Modelica.Units.SI.Force Fy=0;
  Modelica.Units.SI.Acceleration ay;
  Real DeltaModi[nb];
  Modelica.Mechanics.Rotational.Interfaces.Flange_a shaft annotation(
    Placement(transformation(origin = {-100, 54}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-98, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Translational.Interfaces.Flange_a X annotation(
    Placement(transformation(origin = {-100, 72}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {98, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Translational.Interfaces.Flange_a Y annotation(
    Placement(transformation(origin = {-98, 30}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {0, 116}, extent = {{-10, -10}, {10, 10}})));
equation

  // Shaft frequency
  ws = der(shaft.phi);
  der(ws)*1=shaft.tau-0.01;

  // cage frequency 
  wc = (1 - Db/Dp)*ws/2;
  
  // theta_raw for every ball
  for j in 1:nb loop
    ThetaRaw[j] = mod(2*pi*(j - 1)/nb + wc*time, 2*pi);
  end for;
  
  // how is the abslote angular change caused by slip: depends on mutation percentage and PhiSlip
  ThetaChange = mut*0.5*PhiSlip;
  
  //according to if the ball goes into the load zone, modify the theta for each ball
  for j in 1:nb loop
    if ThetaRaw[j] >= pi + n*pi and ThetaRaw[j] <= 2*pi - n*pi then
      Theta[j] = ThetaRaw[j] + ThetaChange;
      loadzone[j] = 1;
    else
      Theta[j] = ThetaRaw[j] - ThetaChange;
      loadzone[j] = 0;
    end if;
  end for;
  
  //block 2: for delta
  DeltaRaw = X.s*cos(Theta).*loadzone + Y.s*sin(Theta).*loadzone .- c;
  //  delta_raw = u1 * cos(theta) + u2 * sin(theta) .- c;
  
  // according to if delta bigger than 0 to remove some deformation values
  for j in 1:nb loop
    Delta[j] = max(DeltaRaw[j], 0);
  end for;
  
  //contact force
  for j in 1:nb loop
    DeltaModi[j] = abs(Delta[j])^1.5;
    force_x[j] = Kb*cos(Theta[j])*DeltaModi[j];
    force_y[j] = Kb*sin(Theta[j])*DeltaModi[j];
  end for;
  X.f - sum(force_x)=Fx;
  Y.f - sum(force_y)=Fy;
  ay = der(Fy)
  annotation(
    uses(Modelica(version = "4.0.0")),
    Icon(graphics = {Rectangle(origin = {-1, 27}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-99, 93}, {101, -135}}), Text(origin = {3, -8}, textColor = {0, 0, 255}, extent = {{-83, 56}, {65, -25}}, textString = "Healthy 
Bearing", fontName = "Arial", textStyle = {TextStyle.Bold}), Rectangle(origin = {0, 6}, lineThickness = 0.75, extent = {{-100, 114}, {100, -114}}), Text(origin = {2, 104}, extent = {{12, -20}, {-12, 0}}, textString = "Y"), Text(origin = {3, -8}, textColor = {0, 0, 255}, extent = {{-83, 56}, {65, -25}}, textString = "Healthy 
Bearing", fontName = "Arial", textStyle = {TextStyle.Bold}), Text(origin = {76, 10}, extent = {{12, -20}, {-12, 0}}, textString = "X")}, coordinateSystem(initialScale = 0.1)),
    Diagram,
    __OpenModelica_commandLineOptions = "");

end BearingHealty;
