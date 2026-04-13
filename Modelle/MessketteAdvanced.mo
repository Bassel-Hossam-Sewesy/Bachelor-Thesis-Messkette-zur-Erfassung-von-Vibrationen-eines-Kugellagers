model Messketteadvanced
  BearingLibrary.VirtualBench_layout_v1 virtualBench_layout_v1(fs_command = 17)  annotation(
    Placement(transformation(origin = {-141, -7}, extent = {{-15, -15}, {15, 15}})));
  IEPE_WithChargeAmplifier_Block iEPE_WithChargeAmplifier_Block annotation(
    Placement(transformation(origin = {-61, -5}, extent = {{-25, -25}, {25, 25}})));
  Modelica.Blocks.Continuous.LowpassButterworth lowpassButterworth1(f = 1000, n = 4) annotation(
    Placement(transformation(origin = {24, 0}, extent = {{-22, -22}, {22, 22}})));
  Modelica.Blocks.Discrete.Sampler sampler1(samplePeriod = 1/5120) annotation(
    Placement(transformation(origin = {89, 3}, extent = {{-13, -13}, {13, 13}})));
  Modelica.Blocks.Discrete.ZeroOrderHold zeroOrderHold1(samplePeriod = 1/5120) annotation(
    Placement(transformation(origin = {172, 4}, extent = {{-16, -16}, {16, 16}})));
  ADU adu1(Umax = 12, Umin = 11, steps = 4092) annotation(
    Placement(transformation(origin = {224, 4}, extent = {{-14, -14}, {14, 14}})));
equation
  connect(virtualBench_layout_v1.acc_x, iEPE_WithChargeAmplifier_Block.acc_x) annotation(
    Line(points = {{-141, 5}, {-116.5, 5}, {-116.5, -5}, {-86, -5}}, color = {0, 0, 127}));
  connect(iEPE_WithChargeAmplifier_Block.v_out, lowpassButterworth1.u) annotation(
    Line(points = {{-36, -5}, {-8, -5}, {-8, 0}, {-2, 0}}, color = {0, 0, 127}));
  connect(lowpassButterworth1.y, sampler1.u) annotation(
    Line(points = {{48, 0}, {73, 0}, {73, 3}}, color = {0, 0, 127}));
  connect(sampler1.y, zeroOrderHold1.u) annotation(
    Line(points = {{103, 3}, {103, 3.5}, {139, 3.5}, {139, 3.75}, {153, 3.75}, {153, 4}}, color = {0, 0, 127}));
  connect(zeroOrderHold1.y, adu1.real_i) annotation(
    Line(points = {{190, 4}, {209, 4}}, color = {0, 0, 127}));
  annotation(
    uses(Modelica(version = "4.0.0")),
  experiment(StartTime = 0, StopTime = 5, Tolerance = 1e-06, Interval = 0.001),
  Diagram(coordinateSystem(extent = {{-160, 40}, {240, -40}})),
  version = "");
end Messketteadvanced;
