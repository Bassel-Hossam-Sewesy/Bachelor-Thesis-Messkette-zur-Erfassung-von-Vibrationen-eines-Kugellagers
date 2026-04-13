model IEPE_Sensor "Flangeless IEPE für Bearing!"
  import Modelica;
  
  Modelica.Blocks.Interfaces.RealInput accel_in "Input: Bearing acc_x [m/s2]" annotation(
    Placement(transformation(origin = {-110, 60}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput v_iepe "Output: IEPE Voltage [V]" annotation(
    Placement(transformation(origin = {70, 62}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}})));
  
  parameter Real piezo_gain = 1e-3 "V/(m/s2)";
  
equation 
  v_iepe = 10 + piezo_gain * accel_in;  
end IEPE_Sensor;
