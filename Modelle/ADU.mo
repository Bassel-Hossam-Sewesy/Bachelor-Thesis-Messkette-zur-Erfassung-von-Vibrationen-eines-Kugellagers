model ADU
  Modelica.Blocks.Interfaces.RealInput real_i annotation(
    Placement(visible = true, transformation(extent = {{-110, -10}, {-90, 10}}, rotation = 0), 
    iconTransformation(extent = {{-120, -10}, {-100, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.IntegerOutput int_o annotation(
    Placement(visible = true, transformation(extent = {{90, -10}, {110, 10}}, rotation = 0), 
    iconTransformation(extent = {{100, -10}, {120, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput real_o annotation(
    Placement(visible = true, transformation(extent = {{90, -30}, {110, -10}}, rotation = 0), 
    iconTransformation(extent = {{100, -30}, {120, -10}}, rotation = 0)));
  
  parameter Real Umax = 5 "Umax";
  parameter Real Umin = 0 "Umin";
  parameter Integer steps = 256 "steps";
  
  Real u "u";
  Real u2 "u2 - clamped voltage";
  Integer digit "digit - quantized value";
  Real u3 "u3 - normalized voltage";
  Real Vlsb "LSB voltage";
  
equation
  digit = floor(abs(u3*(steps - 1)) + 0.5);
  int_o = digit;
  real_i = u;
  u2 = max(Umin, min(Umax, u));
  u3 = (u2 - Umin)/(Umax - Umin);
  
  // Umrechnung zurück zu Spannung
  Vlsb = (Umax - Umin)/(steps - 1);
  real_o = Umin + digit * Vlsb;
  
  annotation(
    Icon(coordinateSystem(initialScale = 0.1), graphics = {
      Rectangle(origin = {0, -2}, extent = {{-100, 102}, {100, -98}}), 
      Text(origin = {-18, 14}, extent = {{94, -70}, {-58, 48}}, textString = "ADU"), 
      Rectangle(lineThickness = 1, extent = {{-100, 100}, {100, -100}})}),
    Diagram(coordinateSystem(extent = {{-200, -100}, {200, 100}}, initialScale = 0.05)));
end ADU;
