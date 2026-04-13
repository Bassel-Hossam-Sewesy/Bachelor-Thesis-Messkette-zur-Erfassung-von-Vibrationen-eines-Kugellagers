package BearingLibrary
  model VirtualBench_layout_v1
    import Modelica.Constants.pi;
    parameter Real ms = 3.2638 "kg" annotation(
      Dialog(group = "material parameters"));
    parameter Real phi_d = 0;
    parameter Real fs_command = 10 "Hz, command shaft speed";
    parameter Real Fr_command = -30000 "N, command radial Force on the shaft";
    Modelica.Blocks.Interfaces.RealOutput acc_x annotation(
      Placement(visible = true, transformation(origin = {0, 82}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {0, 82}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
    Modelica.Blocks.Interfaces.RealOutput omega annotation(
      Placement(visible = true, transformation(origin = {-36, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-36, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    parameter Real KM = 100;
    parameter Real TIM = 0.5;
    parameter Real TDM = 0;
    Modelica.Blocks.Math.Feedback feedback1 annotation(
      Placement(visible = true, transformation(origin = {-18, -34}, extent = {{10, 10}, {-10, -10}}, rotation = 0)));
    Modelica.Blocks.Continuous.PID PID1(Td = TDM, Ti = TIM, k = KM) annotation(
      Placement(visible = true, transformation(origin = {-70, -34}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
    BearingLibrary.DrivingSystem.Motor motor1 annotation(
      Placement(visible = true, transformation(origin = {-66, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    BearingLibrary.DrivingSystem.Shaft shaft1 annotation(
      Placement(visible = true, transformation(origin = {-30, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    parameter Real KH = 8e-2;
    parameter Real TIH = 800;
    parameter Real TDH = 0;
    parameter Real Kf2u = 1.643e-5;
    Modelica.Blocks.Math.Feedback feedback2 annotation(
      Placement(visible = true, transformation(origin = {28, -34}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
    Modelica.Blocks.Continuous.PID PID(Td = TDH, Ti = TIH, k = KH) annotation(
      Placement(visible = true, transformation(origin = {70, -34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Math.Gain F2U(k = Kf2u) annotation(
      Placement(visible = true, transformation(origin = {12, -58}, extent = {{10, 10}, {-10, -10}}, rotation = -90)));
    BearingLibrary.LoadingSystem.E_hydraulicsServo e_hydraulicsServo1 annotation(
      Placement(visible = true, transformation(origin = {61, 41}, extent = {{19, -19}, {-19, 19}}, rotation = 0)));
    Modelica.Blocks.Interfaces.RealOutput load annotation(
      Placement(visible = true, transformation(origin = {26, 60}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-122, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  protected
    parameter Real load_command = Fr_command + ms*g "load from hydraulics servo system";
    parameter Real g = 9.80665 "m/s^2";
    Modelica.Blocks.Sources.Ramp load_com(duration = 0.0, height = load_command, startTime = 0) annotation(
      Placement(visible = true, transformation(origin = {50, -84}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
    Modelica.Blocks.Sources.Ramp shaftspeed_com(duration = 0.0, height = fs_command, startTime = 0) annotation(
      Placement(visible = true, transformation(origin = {-50, -84}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    BearingLibrary.Module.TestBearing testBearing1(position = BearingLibrary.DefectType.RaceWay) annotation(
      Placement(visible = true, transformation(origin = {0, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    connect(shaftspeed_com.y, feedback1.u1) annotation(
      Line(points = {{-39, -84}, {-4, -84}, {-4, -34}, {-10, -34}}, color = {0, 0, 127}));
    connect(load_com.y, F2U.u) annotation(
      Line(points = {{39, -84}, {12, -84}, {12, -70}}, color = {0, 0, 127}));
    connect(F2U.y, feedback2.u1) annotation(
      Line(points = {{12, -47}, {12, -34.5}, {20, -34.5}, {20, -34}}, color = {0, 0, 127}));
    connect(PID.y, e_hydraulicsServo1.Ue) annotation(
      Line(points = {{81, -34}, {96, -34}, {96, 41}, {84, 41}}, color = {0, 0, 127}));
    connect(feedback2.y, PID.u) annotation(
      Line(points = {{37, -34}, {58, -34}}, color = {0, 0, 127}));
    connect(e_hydraulicsServo1.y1, feedback2.u2) annotation(
      Line(points = {{36, 31}, {28, 31}, {28, -26}}, color = {0, 0, 127}));
    connect(PID1.y, motor1.v) annotation(
      Line(points = {{-81, -34}, {-92, -34}, {-92, 32}, {-78, 32}}, color = {0, 0, 127}));
    connect(feedback1.y, PID1.u) annotation(
      Line(points = {{-27, -34}, {-58, -34}}, color = {0, 0, 127}));
    connect(shaft1.f_out, feedback1.u2) annotation(
      Line(points = {{-18, 32}, {-18, -26}}, color = {0, 0, 127}));
    connect(e_hydraulicsServo1.y4, testBearing1.load) annotation(
      Line(points = {{32.5, 41}, {21.5, 41}, {21.5, 32}, {12, 32}}, color = {0, 0, 127}));
    connect(testBearing1.acc_x, acc_x) annotation(
      Line(points = {{0, 43.2}, {0, 82}}, color = {0, 0, 127}));
    connect(shaft1.f_out, testBearing1.omega) annotation(
      Line(points = {{-18.4, 32}, {-14.4, 32}, {-14.4, 32}, {-12.4, 32}}, color = {0, 0, 127}));
    connect(motor1.Torque, shaft1.u) annotation(
      Line(points = {{-65, 44}, {-28, 44}}, color = {0, 0, 127}));
    connect(motor1.f, shaft1.f_in) annotation(
      Line(points = {{-55, 32}, {-42, 32}}, color = {0, 0, 127}));
    load = testBearing1.load;
    omega = 2*pi*testBearing1.omega;
    annotation(
      Diagram,
      __OpenModelica_commandLineOptions = "",
  experiment(StartTime = 0, StopTime = 10, Tolerance = 1e-06, Interval = 0.001));
  end VirtualBench_layout_v1;

  package Module
    model TestBearing
      // outer or inner:
      parameter Integer race[:] = {1} "1 for outer, 2 for inner" annotation(
        Dialog(tab = "Defect properties", group = "race"));
      parameter Real B[rd] = {10e-4} "m" annotation(
        Dialog(tab = "Defect properties", group = "race"));
      parameter Real H[rd] = {6e-4} "m" annotation(
        Dialog(tab = "Defect properties", group = "race"));
      parameter Real L[rd] = {3e-4} "m" annotation(
        Dialog(tab = "Defect properties", group = "race"));
      parameter Real lambda[rd] = {0.2} annotation(
        Dialog(tab = "Defect properties", group = "race"));
      parameter Real phi_d[rd] = {0} "degree,each defect initial position" annotation(
        Dialog(tab = "Defect properties", group = "race"));
      //ball:
      parameter Integer ball[:] = {3} "3 for ball" annotation(
        Dialog(tab = "Defect properties", group = "ball"));
      parameter Integer k[bd] = {4} "order of each defect ball" annotation(
        Dialog(tab = "Defect properties", group = "ball"));
      parameter Real w[bd] = {3e-3} "m,width of spall" annotation(
        Dialog(tab = "Defect properties", group = "ball"));
      parameter Real phi_s_ini[bd] = {0} "rad,spall initial position" annotation(
        Dialog(tab = "Defect properties", group = "ball"));
      // bearing geometrical and material properties:
      parameter Real ms = 3.2638 "kg" annotation(
        Dialog(tab = "Material parameters"));
      parameter Real ks = 7.42e7 "N/m" annotation(
        Dialog(tab = "Material parameters"));
      parameter Real cs = 1376.8 "Ns/m" annotation(
        Dialog(tab = "Material parameters"));
      parameter Real mp = 6.638 "kg" annotation(
        Dialog(tab = "Material parameters"));
      parameter Real kp = 1.51e7 "N/m" annotation(
        Dialog(tab = "Material parameters"));
      parameter Real cp = 2210.7 "Ns/m" annotation(
        Dialog(tab = "Material parameters"));
      parameter Real mr = 1 "kg" annotation(
        Dialog(tab = "Material parameters"));
      parameter Real kr = 8.8826e9 "N/m" annotation(
        Dialog(tab = "Material parameters"));
      parameter Real cr = 9424.8 "Ns/m" annotation(
        Dialog(tab = "Material parameters"));
      parameter Integer nb = 9 annotation(
        Dialog(tab = "Design parameters"));
      parameter Real Dp = 39.32e-3 "m" annotation(
        Dialog(tab = "Design parameters"));
      parameter Real Db = 7.94e-3 "m" annotation(
        Dialog(tab = "Design parameters"));
      parameter Real phi_slip = 0.01 "rad" annotation(
        Dialog(tab = "Design parameters"));
      parameter Real mut = 0 "mutation percentage" annotation(
        Dialog(tab = "Design parameters"));
      parameter Real kb = 1.89e10 "N/m" annotation(
        Dialog(tab = "Design parameters"));
      parameter Real c = 0 "m" annotation(
        Dialog(tab = "Design parameters"));
      parameter Real alpha = 0 "rad" annotation(
        Dialog(tab = "Design parameters"));
      parameter BearingLibrary.DefectType position annotation(
        Dialog(group = "Defect type"));
      Real g = 9.80665 "m/s^2";
      //hidden parameter:
    //protected
    public
      parameter Real n = 0;
      parameter Integer rd = size(race, 1) "number of race defect";
      parameter Integer bd = size(ball, 1) "number of defective balls";
      Modelica.Blocks.Interfaces.RealOutput acc_x annotation(
        Placement(visible = true, transformation(origin = {10, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 112}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
      Modelica.Blocks.Interfaces.RealInput omega annotation(
        Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealInput load annotation(
        Placement(visible = true, transformation(origin = {120, 0}, extent = {{20, -20}, {-20, 20}}, rotation = 0), iconTransformation(origin = {120, 0}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
      BearingLibrary.TestBearings.BallDefect Ball(Db = Db, Dp = Dp, alpha = alpha, ball = ball, c = c, cp = cp, cr = cr, cs = cs, k = k, kb = kb, kp = kp, kr = kr, ks = ks, mp = mp, mr = mr, ms = ms, mut = mut, nb = nb, phi_s_ini = phi_s_ini, phi_slip = phi_slip, w = w) annotation(
        Placement(transformation(origin = {68, 40}, extent = {{-10, -10}, {10, 10}})));
      BearingLibrary.TestBearings.Healthy Healthy(Db = Db, Dp = Dp, alpha = alpha, c = c, cp = cp, cr = cr, cs = cs, kb = kb, kp = kp, kr = kr, ks = ks, mp = mp, mr = mr, ms = ms, mut = mut, n = n, nb = nb, phi_slip = phi_slip) annotation(
        Placement(visible = true, transformation(origin = {-20, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      BearingLibrary.TestBearings.RaceDefect Race(B = B, Db = Db, Dp = Dp, H = H, L = L, alpha = alpha, c = c, cp = cp, cr = cr, cs = cs, kb = kb, kp = kp, kr = kr, ks = ks, lambda = lambda, mp = mp, mr = mr, ms = ms, mut = mut, n = n, nb = nb, phi_d = phi_d, phi_slip = phi_slip, race = race) annotation(
        Placement(visible = true, transformation(origin = {-20, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    equation
      connect(load, Healthy.load) annotation(
        Line(points = {{120, 0}, {-4, 0}, {-4, 20}, {-8, 20}, {-8, 20}}, color = {0, 0, 127}));
      connect(load, Race.load) annotation(
        Line(points = {{120, 0}, {60, 0}, {60, -10}, {-8, -10}, {-8, -10}}, color = {0, 0, 127}));
      connect(load, Ball.load) annotation(
        Line(points = {{120, 0}, {60, 0}, {60, 20}, {32, 20}, {32, 20}}, color = {0, 0, 127}));
      connect(omega, Ball.f) annotation(
        Line(points = {{-120, 0}, {-80, 0}, {-80, 38}, {0, 38}, {0, 20}, {8, 20}, {8, 20}}, color = {0, 0, 127}));
      connect(omega, Race.f) annotation(
        Line(points = {{-120, 0}, {-60, 0}, {-60, -10}, {-32, -10}, {-32, -10}}, color = {0, 0, 127}));
      connect(omega, Healthy.f) annotation(
        Line(points = {{-120, 0}, {-60, 0}, {-60, 20}, {-32, 20}, {-32, 20}}, color = {0, 0, 127}));
      if position == DefectType.Healthy then
        acc_x = Healthy.Output;
      elseif position == DefectType.RaceWay then
        acc_x = Race.Output;
      elseif position == DefectType.Ball then
        acc_x = Ball.Output;
      else
        acc_x = 0;
      end if;
      annotation(
        Icon(graphics = {Text(origin = {103, -210}, extent = {{-235, 122}, {33, -16}}, textString = "Test Bearing", fontName = "Arial"), Rectangle(fillColor = {170, 255, 127}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}})}, coordinateSystem(initialScale = 0.1)),
        Diagram(graphics = {Rectangle(origin = {-3, 2}, extent = {{-37, 38}, {43, -42}})}, coordinateSystem(initialScale = 0.1)));
    end TestBearing;

    model DrivingSystem
      import Modelica.Constants.pi;
      parameter Real KM = 100;
      parameter Real TIM = 0.5;
      parameter Real TDM = 0;
      Modelica.Blocks.Math.Feedback feedback1 annotation(
        Placement(visible = true, transformation(origin = {-196, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealOutput f annotation(
        Placement(visible = true, transformation(origin = {-30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Continuous.PID PID1(Td = TDM, Ti = TIM, k = KM) annotation(
        Placement(visible = true, transformation(origin = {-164, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealInput f_com annotation(
        Placement(visible = true, transformation(origin = {-278, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      BearingLibrary.DrivingSystem.Motor motor1 annotation(
        Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      BearingLibrary.DrivingSystem.Shaft shaft1 annotation(
        Placement(visible = true, transformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    equation
      connect(feedback1.u2, f) annotation(
        Line(points = {{-196, -8}, {-196, -8}, {-196, -40}, {-58, -40}, {-58, 0}, {-30, 0}, {-30, 0}}, color = {0, 0, 127}));
      connect(motor1.Torque, shaft1.u) annotation(
        Line(points = {{-118, 12}, {-78, 12}, {-78, 12}, {-78, 12}}, color = {0, 0, 127}));
      connect(shaft1.f_out, f) annotation(
        Line(points = {{-68, 0}, {-38, 0}, {-38, 0}, {-30, 0}}, color = {0, 0, 127}));
      connect(motor1.f, shaft1.f_in) annotation(
        Line(points = {{-108, 0}, {-92, 0}, {-92, 0}, {-92, 0}}, color = {0, 0, 127}));
      connect(PID1.y, motor1.v) annotation(
        Line(points = {{-152, 0}, {-134, 0}, {-134, 0}, {-132, 0}}, color = {0, 0, 127}));
      connect(f_com, feedback1.u1) annotation(
        Line(points = {{-278, 0}, {-206, 0}, {-206, 0}, {-204, 0}}, color = {0, 0, 127}));
      connect(feedback1.y, PID1.u) annotation(
        Line(points = {{-187, 0}, {-177, 0}, {-177, 0}, {-177, 0}}, color = {0, 0, 127}));
      annotation(
        Diagram(coordinateSystem(extent = {{-300, -100}, {300, 100}}, initialScale = 0.1), graphics = {Rectangle(origin = {-124, 12}, lineColor = {255, 0, 0}, lineThickness = 0.5, extent = {{-20, 8}, {64, -32}}), Text(origin = {-105, -25}, lineColor = {255, 0, 0}, extent = {{-11, 3}, {45, -5}}, textString = "driving motor and shaft", fontName = "Arial", textStyle = {TextStyle.Italic}), Rectangle(origin = {-160, 6}, lineColor = {255, 170, 127}, pattern = LinePattern.Dash, lineThickness = 0.5, extent = {{-50, 20}, {106, -60}}), Text(origin = {-100, -60}, lineColor = {255, 170, 127}, extent = {{-25, 3}, {50, -5}}, textString = "driving control system", fontName = "Arial", textStyle = {TextStyle.Italic})}),
        Icon(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(lineColor = {255, 170, 255}, pattern = LinePattern.DashDotDot, lineThickness = 1, extent = {{-100, 100}, {100, -100}}), Text(origin = {7, -131}, extent = {{-47, 9}, {47, -9}}, textString = "DrivingSystem", fontName = "Arial", textStyle = {TextStyle.Bold})}),
        __OpenModelica_commandLineOptions = "");
    end DrivingSystem;

    model LoadingSystem
      import Modelica.Constants.pi;
      parameter Real KH = 8e-2;
      parameter Real TIH = 800;
      parameter Real TDH = 0;
      parameter Real Kf2u = 1.643e-5;
      Modelica.Blocks.Math.Feedback feedback2 annotation(
        Placement(visible = true, transformation(origin = {178, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealOutput load annotation(
        Placement(visible = true, transformation(origin = {30, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-122, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
      Modelica.Blocks.Continuous.PID PID(Td = TDH, Ti = TIH, k = KH) annotation(
        Placement(visible = true, transformation(origin = {142, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
      Modelica.Blocks.Math.Gain F2U(k = Kf2u) annotation(
        Placement(visible = true, transformation(origin = {210, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealInput F_comm annotation(
        Placement(visible = true, transformation(origin = {274, 0}, extent = {{20, 20}, {-20, -20}}, rotation = 0), iconTransformation(origin = {122, 0}, extent = {{20, 20}, {-20, -20}}, rotation = 0)));
      BearingLibrary.LoadingSystem.E_hydraulicsServo e_hydraulicsServo1 annotation(
        Placement(visible = true, transformation(origin = {90, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
    equation
      connect(e_hydraulicsServo1.y1, feedback2.u2) annotation(
        Line(points = {{76, -6}, {58, -6}, {58, -40}, {178, -40}, {178, -8}, {178, -8}}, color = {0, 0, 127}));
      connect(e_hydraulicsServo1.y4, load) annotation(
        Line(points = {{74, 0}, {38, 0}, {38, 0}, {30, 0}}, color = {0, 0, 127}));
      connect(PID.y, e_hydraulicsServo1.Ue) annotation(
        Line(points = {{132, 0}, {102, 0}, {102, 0}, {102, 0}}, color = {0, 0, 127}));
      connect(F_comm, F2U.u) annotation(
        Line(points = {{274, 0}, {222, 0}, {222, 0}, {222, 0}}, color = {0, 0, 127}));
      connect(F2U.y, feedback2.u1) annotation(
        Line(points = {{199, 0}, {187, 0}, {187, 0}, {185, 0}}, color = {0, 0, 127}));
      connect(feedback2.y, PID.u) annotation(
        Line(points = {{169, 0}, {155, 0}, {155, 0}, {153, 0}}, color = {0, 0, 127}));
      annotation(
        Diagram(coordinateSystem(extent = {{-300, -100}, {300, 100}}, initialScale = 0.1), graphics = {Rectangle(origin = {124, 14}, lineColor = {255, 0, 0}, lineThickness = 0.5, extent = {{-64, 6}, {-2, -34}}), Text(origin = {75, -25}, lineColor = {255, 0, 0}, extent = {{-11, 3}, {47, -5}}, textString = "hydraulics servo", fontName = "Arial", textStyle = {TextStyle.Italic}), Rectangle(origin = {158, 10}, lineColor = {255, 170, 127}, pattern = LinePattern.Dash, lineThickness = 0.5, extent = {{-104, 16}, {74, -60}}), Text(origin = {80, -60}, lineColor = {255, 170, 127}, extent = {{-25, 3}, {50, -5}}, textString = "loading control system", fontName = "Arial", textStyle = {TextStyle.Italic})}),
        Icon(graphics = {Text(origin = {6, -125}, extent = {{-34, 13}, {34, -13}}, textString = "LoadingSystem", fontName = "Arial", textStyle = {TextStyle.Bold}), Rectangle(lineColor = {255, 170, 127}, fillColor = {255, 170, 127}, pattern = LinePattern.DashDotDot, lineThickness = 1, extent = {{-100, 100}, {100, -100}})}),
        __OpenModelica_commandLineOptions = "");
    end LoadingSystem;

    model TestBearing_b
      parameter Real n = 0;
      // outer or inner:
      parameter Integer race[:] = {1} "1 for outer, 2 for inner" annotation(
        Dialog(group = "defect properties_race"));
      parameter Real B[rd] = {10e-4} "m" annotation(
        Dialog(group = "defect properties_race"));
      parameter Real H[rd] = {6e-4} "m" annotation(
        Dialog(group = "defect properties_race"));
      parameter Real L[rd] = {3e-4} "m" annotation(
        Dialog(group = "defect properties_race"));
      parameter Real lambda[rd] = {0.2} annotation(
        Dialog(group = "defect properties_race"));
      parameter Real phi_d[rd] = {0} "degree,each defect initial position" annotation(
        Dialog(group = "defect properties_race"));
      //ball:
      parameter Integer ball[:] = {3} "3 for ball" annotation(
        Dialog(group = "defect properties_ball"));
      parameter Integer k[bd] = {4} "order of each defect ball" annotation(
        Dialog(group = "defect properties_ball"));
      parameter Real w[bd] = {3e-3} "m,width of spall" annotation(
        Dialog(group = "defect properties_ball"));
      parameter Real phi_s_ini[bd] = {0} "rad,spall initial position" annotation(
        Dialog(group = "defect properties_ball"));
      // bearing geometrical and material properties:
      parameter Real ms = 3.2638 "kg" annotation(
        Dialog(group = "material parameters"));
      parameter Real ks = 7.42e7 "N/m" annotation(
        Dialog(group = "material parameters"));
      parameter Real cs = 1376.8 "Ns/m" annotation(
        Dialog(group = "material parameters"));
      parameter Real mp = 6.638 "kg" annotation(
        Dialog(group = "material parameters"));
      parameter Real kp = 1.51e7 "N/m" annotation(
        Dialog(group = "material parameters"));
      parameter Real cp = 2210.7 "Ns/m" annotation(
        Dialog(group = "material parameters"));
      parameter Real mr = 1 "kg" annotation(
        Dialog(group = "material parameters"));
      parameter Real kr = 8.8826e9 "N/m" annotation(
        Dialog(group = "material parameters"));
      parameter Real cr = 9424.8 "Ns/m" annotation(
        Dialog(group = "material parameters"));
      parameter Integer nb = 9 annotation(
        Dialog(group = "design parameters"));
      parameter Real Dp = 39.32e-3 "m" annotation(
        Dialog(group = "design parameters"));
      parameter Real Db = 7.94e-3 "m" annotation(
        Dialog(group = "design parameters"));
      parameter Real phi_slip = 0.01 "rad" annotation(
        Dialog(group = "design parameters"));
      parameter Real mut = 0 "mutation percentage" annotation(
        Dialog(group = "design parameters"));
      parameter Real kb = 1.89e10 "N/m" annotation(
        Dialog(group = "design parameters"));
      parameter Real c = 0 "m" annotation(
        Dialog(group = "design parameters"));
      parameter Real alpha = 0 "rad" annotation(
        Dialog(group = "design parameters"));
      parameter String position = "healthy" "position has: race, ball, mix, otherwise: healthy";
      parameter Real g = 9.80665 "m/s^2" annotation(
        Dialog(group = "others"));
      //hidden parameter:
      parameter Integer rd = size(race, 1) "number of race defect" annotation(
        Dialog(group = "defect number"));
      parameter Integer bd = size(ball, 1) "number of defective balls" annotation(
        Dialog(group = "defect number"));
      Modelica.Blocks.Interfaces.RealOutput Output annotation(
        Placement(visible = true, transformation(origin = {6, 106}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 112}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
      Modelica.Blocks.Interfaces.RealInput omega annotation(
        Placement(visible = true, transformation(origin = {-126, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-126, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealInput load annotation(
        Placement(visible = true, transformation(origin = {124, 0}, extent = {{20, -20}, {-20, 20}}, rotation = 0), iconTransformation(origin = {124, 0}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
      BearingLibrary.TestBearings.BallDefect Ball(Db = Db, Dp = Dp, alpha = alpha, ball = ball, c = c, cp = cp, cr = cr, cs = cs, k = k, kb = kb, kp = kp, kr = kr, ks = ks, mp = mp, mr = mr, ms = ms, mut = mut, nb = nb, phi_s_ini = phi_s_ini, phi_slip = phi_slip, w = w) annotation(
        Placement(visible = true, transformation(origin = {58, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      BearingLibrary.TestBearings.Healthy Healthy(Db = Db, Dp = Dp, alpha = alpha, c = c, cp = cp, cr = cr, cs = cs, kb = kb, kp = kp, kr = kr, ks = ks, mp = mp, mr = mr, ms = ms, mut = mut, n = n, nb = nb, phi_slip = phi_slip) annotation(
        Placement(visible = true, transformation(origin = {-50, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      BearingLibrary.TestBearings.RaceDefect Race(B = B, Db = Db, Dp = Dp, H = H, L = L, alpha = alpha, c = c, cp = cp, cr = cr, cs = cs, kb = kb, kp = kp, kr = kr, ks = ks, lambda = lambda, mp = mp, mr = mr, ms = ms, mut = mut, n = n, nb = nb, phi_d = phi_d, phi_slip = phi_slip, race = race) annotation(
        Placement(visible = true, transformation(origin = {-52, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    equation
      connect(load, Healthy.load) annotation(
        Line(points = {{124, 0}, {0, 0}, {0, 60}, {-38, 60}, {-38, 60}}, color = {0, 0, 127}));
      connect(load, Race.load) annotation(
        Line(points = {{124, 0}, {0, 0}, {0, -40}, {-40, -40}, {-40, -40}}, color = {0, 0, 127}));
      connect(omega, Healthy.f) annotation(
        Line(points = {{-126, 0}, {-90, 0}, {-90, 60}, {-62, 60}, {-62, 60}}, color = {0, 0, 127}));
      connect(omega, Race.f) annotation(
        Line(points = {{-126, 0}, {-94, 0}, {-94, -40}, {-64, -40}, {-64, -40}}, color = {0, 0, 127}));
      connect(load, Ball.load) annotation(
        Line(points = {{124, 0}, {98, 0}, {98, 60}, {70, 60}, {70, 60}}, color = {0, 0, 127}));
      connect(omega, Ball.f) annotation(
        Line(points = {{-126, 0}, {-94, 0}, {-94, 82}, {10, 82}, {10, 60}, {46, 60}, {46, 60}}, color = {0, 0, 127}));
      if position == "healthy" then
        Output = Healthy.Output;
      elseif position == "race" then
        Output = Race.Output;
      elseif position == "ball" then
        Output = Ball.Output;
      else
        Output = 0;
      end if;
      annotation(
        Icon(graphics = {Text(origin = {103, -210}, extent = {{-235, 122}, {33, -16}}, textString = "Test Bearing", fontName = "Arial"), Rectangle(fillColor = {170, 255, 127}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}})}, coordinateSystem(initialScale = 0.1)),
        Diagram(graphics = {Rectangle(origin = {-49, 58}, lineColor = {170, 0, 0}, pattern = LinePattern.Dot, extent = {{-37, 38}, {37, -38}}), Rectangle(origin = {57, 58}, lineColor = {170, 0, 0}, pattern = LinePattern.Dot, extent = {{-37, 38}, {37, -38}}), Rectangle(origin = {-49, -42}, lineColor = {170, 0, 0}, pattern = LinePattern.Dot, extent = {{-37, 38}, {37, -38}})}, coordinateSystem(initialScale = 0.1)));
    end TestBearing_b;
  end Module;

  package TestBearings
    model Healthy
      parameter Real n = 0;
      parameter Real innerclockstart = 3;
      parameter Integer nb = 9 annotation(
        Dialog(group = "design parameters"));
      parameter Real Dp = 39.32e-3 "m" annotation(
        Dialog(group = "design parameters"));
      parameter Real Db = 7.94e-3 "m" annotation(
        Dialog(group = "design parameters"));
      parameter Real phi_slip = 0.01 "rad" annotation(
        Dialog(group = "design parameters"));
      parameter Real mut = 0 "mutation percentage" annotation(
        Dialog(group = "design parameters"));
      parameter Real kb = 1.89e10 "N/m" annotation(
        Dialog(group = "design parameters"));
      parameter Real c = 0 "m" annotation(
        Dialog(group = "design parameters"));
      parameter Real alpha = 0 "rad" annotation(
        Dialog(group = "design parameters"));
      parameter Real ms = 3.2638 "kg" annotation(
        Dialog(group = "material parameters"));
      parameter Real ks = 7.42e7 "N/m" annotation(
        Dialog(group = "material parameters"));
      parameter Real cs = 1376.8 "Ns/m" annotation(
        Dialog(group = "material parameters"));
      parameter Real mp = 6.638 "kg" annotation(
        Dialog(group = "material parameters"));
      parameter Real kp = 1.51e7 "N/m" annotation(
        Dialog(group = "material parameters"));
      parameter Real cp = 2210.7 "Ns/m" annotation(
        Dialog(group = "material parameters"));
      parameter Real mr = 1 "kg" annotation(
        Dialog(group = "material parameters"));
      parameter Real kr = 8.8826e9 "N/m" annotation(
        Dialog(group = "material parameters"));
      parameter Real cr = 9424.8 "Ns/m" annotation(
        Dialog(group = "material parameters"));
      parameter Real g = 9.80665 "m/s^2";
      Modelica.Blocks.Interfaces.RealOutput Output annotation(
        Placement(visible = true, transformation(origin = {6, 106}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 112}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
      Modelica.Blocks.Sources.ContinuousClock clock1(offset = 0, startTime = innerclockstart) annotation(
        Placement(visible = true, transformation(origin = {-54, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealInput f annotation(
        Placement(visible = true, transformation(origin = {-126, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-126, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealInput load annotation(
        Placement(visible = true, transformation(origin = {124, 0}, extent = {{20, -20}, {-20, 20}}, rotation = 0), iconTransformation(origin = {124, 0}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
      Components.DefectModel.Healthy HealthyModel(Db = Db, Dp = Dp, c = c, kb = kb, mut = mut, n = n, nb = nb, phi_slip = phi_slip) annotation(
        Placement(transformation(origin = {-14, 28}, extent = {{-14, -14}, {14, 14}})));
      Components.DoF DoF(cp = cp, cr = cr, cs = cs, g = g, kp = kp, kr = kr, ks = ks, mp = mp, mr = mr, ms = ms) annotation(
        Placement(transformation(origin = {2, -40}, extent = {{-20, 20}, {20, -20}})));
    equation
      connect(HealthyModel.acc_x, Output) annotation(
        Line(points = {{3, 42}, {3, 22}, {34, 22}, {34, 104}, {6, 104}, {6, 106}}, color = {0, 0, 127}));
      connect(load, DoF.load) annotation(
        Line(points = {{124, 0}, {52, 0}, {52, -40}, {-22, -40}}, color = {0, 0, 127}));
      connect(HealthyModel.fx, DoF.fx) annotation(
        Line(points = {{1, 22}, {1, 0}, {24, 0}, {24, -56}}, color = {0, 0, 127}));
      connect(HealthyModel.fy, DoF.fy) annotation(
        Line(points = {{1, 14}, {1, -17}, {25, -17}, {25, -24}}, color = {0, 0, 127}));
      connect(DoF.u1, HealthyModel.u1) annotation(
        Line(points = {{-20, -56}, {-36, -56}, {-36, 22}, {-29, 22}}, color = {0, 0, 127}));
      connect(HealthyModel.u2, DoF.u2) annotation(
        Line(points = {{-29, 14}, {-29, -8}, {-20, -8}, {-20, -24}}, color = {0, 0, 127}));
      connect(f, HealthyModel.f) annotation(
        Line(points = {{-126, 0}, {-76, 0}, {-76, 31}, {-31, 31}}, color = {0, 0, 127}));
      connect(clock1.y, HealthyModel.u3) annotation(
        Line(points = {{-42, 48}, {-26, 48}, {-26, 42}, {-31, 42}}, color = {0, 0, 127}));
      annotation(
        Icon(graphics = {Text(origin = {-1, -126}, extent = {{-33, 16}, {33, -16}}, textString = "Healthy", fontName = "Arial"), Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}})}, coordinateSystem(initialScale = 0.1)));
    end Healthy;

    model RaceDefect
      parameter Real n = 0;
      parameter Real innerclockstart = 3;
      parameter Integer nb = 9 annotation(
        Dialog(group = "design parameters"));
      parameter Real Dp = 39.32e-3 "m" annotation(
        Dialog(group = "design parameters"));
      parameter Real Db = 7.94e-3 "m" annotation(
        Dialog(group = "design parameters"));
      parameter Real phi_slip = 0.01 "rad" annotation(
        Dialog(group = "design parameters"));
      parameter Real mut = 0 "mutation percentage" annotation(
        Dialog(group = "design parameters"));
      parameter Real kb = 1.89e10 "N/m" annotation(
        Dialog(group = "design parameters"));
      parameter Real c = 0 "m" annotation(
        Dialog(group = "design parameters"));
      parameter Real alpha = 0 "rad" annotation(
        Dialog(group = "design parameters"));
      parameter Real ms = 3.2638 "kg" annotation(
        Dialog(group = "material parameters"));
      parameter Real ks = 7.42e7 "N/m" annotation(
        Dialog(group = "material parameters"));
      parameter Real cs = 1376.8 "Ns/m" annotation(
        Dialog(group = "material parameters"));
      parameter Real mp = 6.638 "kg" annotation(
        Dialog(group = "material parameters"));
      parameter Real kp = 1.51e7 "N/m" annotation(
        Dialog(group = "material parameters"));
      parameter Real cp = 2210.7 "Ns/m" annotation(
        Dialog(group = "material parameters"));
      parameter Real mr = 1 "kg" annotation(
        Dialog(group = "material parameters"));
      parameter Real kr = 8.8826e9 "N/m" annotation(
        Dialog(group = "material parameters"));
      parameter Real cr = 9424.8 "Ns/m" annotation(
        Dialog(group = "material parameters"));
      parameter Real g = 9.80665 "m/s^2";
      parameter Integer race[:] = {1} "1 for outer, 2 for inner" annotation(
        Dialog(group = "defect properties"));
      parameter Real B[:] = {10e-4} "m" annotation(
        Dialog(group = "defect properties"));
      parameter Real H[:] = {6e-4} "m" annotation(
        Dialog(group = "defect properties"));
      parameter Real L[:] = {3e-4} "m" annotation(
        Dialog(group = "defect properties"));
      parameter Real lambda[:] = {0.2} annotation(
        Dialog(group = "defect properties"));
      parameter Real phi_d[:] = {0} "degree,each defect initial position" annotation(
        Dialog(group = "defect properties"));
      //  parameter Integer rd = size(race,1)"number of race defect" annotation(Dialog(group="defect properties"));
      Modelica.Blocks.Interfaces.RealOutput Output annotation(
        Placement(visible = true, transformation(origin = {6, 106}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 112}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
      Modelica.Blocks.Sources.ContinuousClock clock1(offset = 0, startTime = innerclockstart) annotation(
        Placement(visible = true, transformation(origin = {-54, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealInput f annotation(
        Placement(visible = true, transformation(origin = {-126, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-126, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealInput load annotation(
        Placement(visible = true, transformation(origin = {124, 0}, extent = {{20, -20}, {-20, 20}}, rotation = 0), iconTransformation(origin = {124, 0}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
      Components.DefectModel.Race Race(B = B, Db = Db, Dp = Dp, H = H, L = L, alpha = alpha, c = c, kb = kb, lambda = lambda, mut = mut, n = n, nb = nb, phi_d = phi_d, phi_slip = phi_slip, wz = race) annotation(
        Placement(visible = true, transformation(origin = {0, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Components.DoF DoF(cp = cp, cr = cr, cs = cs, g = g, kp = kp, kr = kr, ks = ks, mp = mp, mr = mr, ms = ms) annotation(
        Placement(visible = true, transformation(origin = {0, -40}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
    equation
      connect(clock1.y, Race.u3) annotation(
        Line(points = {{-42, 48}, {-26, 48}, {-26, 24}, {-12, 24}}, color = {0, 0, 127}));
      connect(f, Race.f) annotation(
        Line(points = {{-126, 0}, {-76, 0}, {-76, 18}, {-12, 18}}, color = {0, 0, 127}));
      connect(Race.u2, DoF.u2) annotation(
        Line(points = {{-12, 8}, {-28, 8}, {-28, -32}, {-12, -32}}, color = {0, 0, 127}));
      connect(DoF.u1, Race.u1) annotation(
        Line(points = {{-12, -48}, {-36, -48}, {-36, 12}, {-12, 12}}, color = {0, 0, 127}));
      connect(Race.fy, DoF.fy) annotation(
        Line(points = {{11, 8}, {16, 8}, {16, -32}, {12, -32}}, color = {0, 0, 127}));
      connect(Race.fx, DoF.fx) annotation(
        Line(points = {{11, 12}, {24, 12}, {24, -48}, {12, -48}}, color = {0, 0, 127}));
      connect(Race.acc_x, Output) annotation(
        Line(points = {{12, 24}, {32, 24}, {32, 104}, {6, 104}, {6, 106}}, color = {0, 0, 127}));
      connect(load, DoF.load) annotation(
        Line(points = {{124, 0}, {52, 0}, {52, -66}, {-54, -66}, {-54, -40}, {-12, -40}, {-12, -40}}, color = {0, 0, 127}));
      annotation(
        Icon(graphics = {Text(origin = {-1, -126}, extent = {{-33, 16}, {33, -16}}, textString = "Race", fontName = "Arial"), Rectangle(fillColor = {255, 255, 127}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}})}, coordinateSystem(initialScale = 0.1)));
    end RaceDefect;

    model BallDefect
      parameter Real innerclockstart = 3;
      parameter Integer nb = 9 annotation(
        Dialog(group = "design parameters"));
      parameter Real Dp = 39.32e-3 "m" annotation(
        Dialog(group = "design parameters"));
      parameter Real Db = 7.94e-3 "m" annotation(
        Dialog(group = "design parameters"));
      parameter Real phi_slip = 0.01 "rad" annotation(
        Dialog(group = "design parameters"));
      parameter Real mut = 0 "mutation percentage" annotation(
        Dialog(group = "design parameters"));
      parameter Real kb = 1.89e10 "N/m" annotation(
        Dialog(group = "design parameters"));
      parameter Real c = 0 "m" annotation(
        Dialog(group = "design parameters"));
      parameter Real alpha = 0 "rad" annotation(
        Dialog(group = "design parameters"));
      parameter Real ms = 3.2638 "kg" annotation(
        Dialog(group = "material parameters"));
      parameter Real ks = 7.42e7 "N/m" annotation(
        Dialog(group = "material parameters"));
      parameter Real cs = 1376.8 "Ns/m" annotation(
        Dialog(group = "material parameters"));
      parameter Real mp = 6.638 "kg" annotation(
        Dialog(group = "material parameters"));
      parameter Real kp = 1.51e7 "N/m" annotation(
        Dialog(group = "material parameters"));
      parameter Real cp = 2210.7 "Ns/m" annotation(
        Dialog(group = "material parameters"));
      parameter Real mr = 1 "kg" annotation(
        Dialog(group = "material parameters"));
      parameter Real kr = 8.8826e9 "N/m" annotation(
        Dialog(group = "material parameters"));
      parameter Real cr = 9424.8 "Ns/m" annotation(
        Dialog(group = "material parameters"));
      parameter Real g = 9.80665 "m/s^2";
      parameter Integer ball[:] = {3} "1 for outer, 2 for inner, 3 for ball" annotation(
        Dialog(group = "defect properties_ball"));
      parameter Integer k[bd] = {4} "order of each defect ball" annotation(
        Dialog(group = "defect properties_ball"));
      parameter Real w[bd] = {3e-3} "m,width of spall" annotation(
        Dialog(group = "defect properties_ball"));
      parameter Real phi_s_ini[bd] = {0} "rad,spall initial position" annotation(
        Dialog(group = "defect properties_ball"));
    //protected
    public
      parameter Integer bd = size(ball, 1) "number of defective balls" annotation(
        Dialog(group = "defect properties_ball"));
      Modelica.Blocks.Interfaces.RealOutput Output annotation(
        Placement(visible = true, transformation(origin = {6, 106}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 112}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
      Modelica.Blocks.Sources.ContinuousClock clock1(offset = 0, startTime = innerclockstart) annotation(
        Placement(visible = true, transformation(origin = {-54, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealInput f annotation(
        Placement(visible = true, transformation(origin = {-126, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-126, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealInput load annotation(
        Placement(visible = true, transformation(origin = {124, 0}, extent = {{20, -20}, {-20, 20}}, rotation = 0), iconTransformation(origin = {124, 0}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
      Components.DoF DoF(cp = cp, cr = cr, cs = cs, g = g, kp = kp, kr = kr, ks = ks, mp = mp, mr = mr, ms = ms) annotation(
        Placement(visible = true, transformation(origin = {0, -40}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
      Components.DefectModel.Ball Ball(Db = Db, Dp = Dp, alpha = alpha, c = c, k = k, kb = kb, mut = mut, nb = nb, phi_s_ini = phi_s_ini, phi_slip = phi_slip, w = w, wz = ball) annotation(
        Placement(transformation(origin = {4, 0}, extent = {{-10, -10}, {10, 10}})));
    equation
      connect(DoF.u1, Ball.u1) annotation(
        Line(points = {{-10, -48}, {-38, -48}, {-38, 6}, {-7, 6}}, color = {0, 0, 127}));
      connect(DoF.u2, Ball.u2) annotation(
        Line(points = {{-10, -32}, {-22, -32}, {-22, -2}, {-7, -2}}, color = {0, 0, 127}));
      connect(Ball.fx, DoF.fx) annotation(
        Line(points = {{15, -2}, {38, -2}, {38, -48}, {12, -48}}, color = {0, 0, 127}));
      connect(Ball.fy, DoF.fy) annotation(
        Line(points = {{15, -6}, {26, -6}, {26, -32}, {12, -32}}, color = {0, 0, 127}));
      connect(Ball.acc_x, Output) annotation(
        Line(points = {{15, 6}, {15, 104}, {6, 104}, {6, 106}}, color = {0, 0, 127}));
      connect(f, Ball.f) annotation(
        Line(points = {{-126, 0}, {-68, 0}, {-68, 2}, {-7, 2}}, color = {0, 0, 127}));
      connect(clock1.y, Ball.u3) annotation(
        Line(points = {{-42, 48}, {-24, 48}, {-24, -6}, {-7, -6}}, color = {0, 0, 127}));
      connect(load, DoF.load) annotation(
        Line(points = {{124, 0}, {52, 0}, {52, -66}, {-54, -66}, {-54, -40}, {-12, -40}, {-12, -40}}, color = {0, 0, 127}));
      annotation(
        Icon(graphics = {Text(origin = {-1, -126}, extent = {{-33, 16}, {33, -16}}, textString = "Ball", fontName = "Arial"), Rectangle(fillColor = {255, 170, 127}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}})}, coordinateSystem(initialScale = 0.1)));
    end BallDefect;

    package Components
      model DoF
        import Modelica.Constants.pi;
        //parameters
        parameter Real ms = 3.2638 "kg";
        parameter Real ks = 7.42e7 "N/m";
        parameter Real cs = 1376.8 "Ns/m";
        parameter Real mp = 6.638 "kg";
        parameter Real kp = 1.51e7 "N/m";
        parameter Real cp = 2210.7 "Ns/m";
        parameter Real mr = 1 "kg";
        parameter Real kr = 8.8826e9 "N/m";
        parameter Real cr = 9424.8 "Ns/m";
        parameter Real g = 9.80665;
        Real ys;
        Real yp;
        Real xs;
        Real xp;
        Real yb;
        Real vys = der(ys);
        Real vyp = der(yp);
        Real vyb = der(yb);
        Real vxs = der(xs);
        Real vxp = der(xp);
        Real Fr = load - ms*g;
        Modelica.Blocks.Interfaces.RealInput fx annotation(
          Placement(visible = true, transformation(origin = {78, 72}, extent = {{20, -20}, {-20, 20}}, rotation = 0), iconTransformation(origin = {112, 80}, extent = {{12, -12}, {-12, 12}}, rotation = 0)));
        Modelica.Blocks.Interfaces.RealOutput u1 "xs-xp" annotation(
          Placement(visible = true, transformation(origin = {-90, 82}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-110, 80}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
        Modelica.Blocks.Interfaces.RealInput fy annotation(
          Placement(visible = true, transformation(origin = {84, -28}, extent = {{20, -20}, {-20, 20}}, rotation = 0), iconTransformation(origin = {114, -80}, extent = {{14, -14}, {-14, 14}}, rotation = 0)));
        Modelica.Blocks.Interfaces.RealOutput u2 "ys-yp" annotation(
          Placement(visible = true, transformation(origin = {-92, -60}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-110, -80}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
        Modelica.Blocks.Interfaces.RealInput load "Force from hydraulics servo system" annotation(
          Placement(visible = true, transformation(origin = {42, -76}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-122, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      equation
        ms*der(vxs) + cs*der(xs) + ks*xs + fx = 0;
        ms*der(vys) + cs*der(ys) + ks*ys + fy = Fr;
        mp*der(vxp) + cp*der(xp) + kp*xp - fx = 0;
        mp*der(vyp) + (cp + cr)*der(yp) + (kp + kr)*yp - kr*yb - cr*der(yb) + mp*g - fy = 0;
        mr*der(vyb) + cr*(der(yb) - der(yp)) + kr*(yb - yp) + mr*g = 0;
        u1 = xs - xp;
        u2 = ys - yp;
        annotation(
          Icon(graphics = {Text(origin = {-1, -136}, extent = {{-41, 18}, {41, -18}}, textString = "5-DoF", fontName = "Arial", textStyle = {TextStyle.Bold}), Rectangle(extent = {{-100, 100}, {100, -100}})}));
      end DoF;

      package DefectModel
        model Healthy
          import Modelica.Constants.pi;
          //part 1
          parameter Real n = 0;
          parameter Integer nb = 4;
          //  parameter Real f = 25 "Hz";
          parameter Real Db = 7.94e-3 "m";
          parameter Real Dp = 39.32e-3 "m";
          parameter Real phi_slip = 0.01 "rad";
          parameter Real mut = 0 "mutation percentage";
          parameter Real kb = 1.89e10 "N/m";
          parameter Real c = 1e-5 "m, bearing clearance";
          Real ws;
          Real wc;
          Real theta_change;
          //add inner variables
          //blcok 1
          Real theta_raw[nb];
          Real theta[nb];
          Real loadzone[nb];
          //the balls that enter the load zone are deformed
          //block 2
          Real delta_raw[nb];
          Real delta[nb];
          //block 3
          Real force_x[nb];
          Real force_y[nb];
          Real delta_modi[nb];
          Real v_x;
          Real v_y;
          Modelica.Blocks.Interfaces.RealInput u3 "simutation time" annotation(
            Placement(visible = true, transformation(origin = {-74, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 100}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
          Modelica.Blocks.Interfaces.RealInput f "shaft speed" annotation(
            Placement(visible = true, transformation(origin = {-74, 28}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-122, 18}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
          Modelica.Blocks.Interfaces.RealInput u1 annotation(
            Placement(visible = true, transformation(origin = {-74, -26}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
          Modelica.Blocks.Interfaces.RealInput u2 annotation(
            Placement(visible = true, transformation(origin = {-74, -56}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
          Modelica.Blocks.Interfaces.RealOutput fx annotation(
            Placement(visible = true, transformation(origin = {70, -22}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
          Modelica.Blocks.Interfaces.RealOutput fy annotation(
            Placement(visible = true, transformation(origin = {70, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
          Modelica.Blocks.Interfaces.RealOutput acc_x annotation(
            Placement(visible = true, transformation(origin = {70, 74}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {120, 100}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
          Modelica.Blocks.Interfaces.RealOutput acc_y annotation(
            Placement(visible = true, transformation(origin = {70, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {120, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
        equation
//block 1:for theta
          ws = 2*pi*f;
/*1)wc*/
          wc = (1 - Db/Dp)*ws/2;
/*2)theta_raw for every ball*/
          for j in 1:nb loop
            theta_raw[j] = mod(2*pi*(j - 1)/nb + wc*u3, 2*pi);
          end for;
/*3)how is the abslote angular change caused by slip: depends on mutation percentage and phi_slip*/
          theta_change = mut*0.5*phi_slip;
/*according to if the ball goes into the load zone, modify the theta for each ball*/
          for j in 1:nb loop
            if theta_raw[j] >= pi + n*pi and theta_raw[j] <= 2*pi - n*pi then
              theta[j] = theta_raw[j] + theta_change;
              loadzone[j] = 1;
            else
              theta[j] = theta_raw[j] - theta_change;
              loadzone[j] = 0;
            end if;
          end for;
//block 2: for delta
          delta_raw = u1*cos(theta).*loadzone + u2*sin(theta).*loadzone .- c;
//  delta_raw = u1 * cos(theta) + u2 * sin(theta) .- c;
/*according to if delta bigger than 0 to remove some deformation values*/
          for j in 1:nb loop
            delta[j] = max(delta_raw[j], 0);
          end for;
//block 3: for contact force
          for j in 1:nb loop
            delta_modi[j] = abs(delta[j])^1.5;
            force_x[j] = kb*cos(theta[j])*delta_modi[j];
            force_y[j] = kb*sin(theta[j])*delta_modi[j];
          end for;
          fx = sum(force_x);
          fy = sum(force_y);
          v_x = der(u1);
          v_y = der(u2);
          acc_x = der(v_x);
          acc_y = der(v_y);
          annotation(
            uses(Modelica(version = "3.2.2")),
            Icon(graphics = {Rectangle(origin = {-1, 27}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-99, 93}, {101, -135}}), Text(origin = {0, 137}, lineColor = {0, 0, 255}, extent = {{-28, 11}, {22, -5}}, textString = "Healthy", fontName = "Arial", textStyle = {TextStyle.Bold})}, coordinateSystem(initialScale = 0.1)),
            Diagram,
            __OpenModelica_commandLineOptions = "");
        end Healthy;

        model Race
          import Modelica.Constants.pi;
          //part 1
          parameter Real n = 0;
          parameter Integer nb = 9;
          //  parameter Real f = 25 "Hz";
          parameter Real Dp = 39.32e-3 "m";
          parameter Real Db = 7.94e-3 "m";
          parameter Real phi_slip = 0.01 "rad";
          parameter Real mut = 0 "mutation percentage";
          parameter Real kb = 1.89e10 "N/m";
          parameter Real c = 0 "m";
          parameter Real alpha = 0 "rad";
          parameter Integer wz[:] = {1} "1 for outer, 2 for inner" annotation(
            Dialog(group = "defect properties"));
          parameter Real B[:] = {10e-4} "m" annotation(
            Dialog(group = "defect properties"));
          parameter Real H[nd] = {6e-4} "m" annotation(
            Dialog(group = "defect properties"));
          parameter Real L[nd] = {3e-4} "m" annotation(
            Dialog(group = "defect properties"));
          parameter Real lambda[nd] = {0.2} annotation(
            Dialog(group = "defect properties"));
          parameter Real phi_d[nd] = {0} "degree,each defect initial position" annotation(
            Dialog(group = "defect properties"));
        //protected
        public
          parameter Integer nd = size(wz, 1) "number of race defect" annotation(
            Dialog(group = "defect properties"));
          Real ws;
          //shaft speed
          Real wc;
          Real theta_change;
          //add inner variables
          //blcok 1
          Real theta_raw[nb];
          Real theta[nb];
          Real loadzone[nb];
          //block 2
          Real delta_raw[nb];
          Real delta[nb];
          //block 3
          Real force_x[nb];
          Real force_y[nb];
          Real delta_modi[nb];
          //block 4 outer race defect
          Integer race[nd];
          Integer ball[nd];
          Real delta_phi_d[nd] "rad";
          Real Hd[nd];
          Real cd_raw[nd];
          Real fault_start[nd];
          Real fault_end[nd];
          Real phi_1[nd];
          Real phi_2[nd];
          Real eta_bd[nd];
          Real eta_d[nd];
          Real cd[nb, nd];
          Real u[nb, nd] "the angular to each defect start edg";
          //angular of ball for cd of outer race
          Real beta_race[nb, nd];
          Real fault_delta_0[nb, nd];
          Real fault_delta[nb];
          Real v_x;
          Real v_y;
          Modelica.Blocks.Interfaces.RealInput u3 "simutation time" annotation(
            Placement(visible = true, transformation(origin = {-74, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
          Modelica.Blocks.Interfaces.RealInput f "shaft speed" annotation(
            Placement(visible = true, transformation(origin = {-74, 28}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
          Modelica.Blocks.Interfaces.RealInput u1 annotation(
            Placement(visible = true, transformation(origin = {-74, -26}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-118, -40}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
          Modelica.Blocks.Interfaces.RealInput u2 annotation(
            Placement(visible = true, transformation(origin = {-74, -56}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-117, -81}, extent = {{-17, -17}, {17, 17}}, rotation = 0)));
          Modelica.Blocks.Interfaces.RealOutput fx annotation(
            Placement(visible = true, transformation(origin = {70, -22}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
          Modelica.Blocks.Interfaces.RealOutput fy annotation(
            Placement(visible = true, transformation(origin = {70, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
          Modelica.Blocks.Interfaces.RealOutput acc_x annotation(
            Placement(visible = true, transformation(origin = {70, 62}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {120, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
          Modelica.Blocks.Interfaces.RealOutput acc_y annotation(
            Placement(visible = true, transformation(origin = {70, 42}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {120, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
        equation
//block 1:for theta
          ws = 2*pi*f;
/*1)wc cage speed*/
          wc = (1 - Db/Dp)*ws/2;
/*2)theta_raw for every ball*/
          for j in 1:nb loop
            theta_raw[j] = mod(2*pi*(j - 1)/nb + wc*u3, 2*pi);
          end for;
/*3)how is the abslote angular change caused by slip: depends on mutation percentage and phi_slip*/
          theta_change = mut*0.5*phi_slip;
/*according to if the ball goes into the load zone, modify the theta for each ball*/
          for j in 1:nb loop
            if theta_raw[j] >= (1 + n)*pi and theta_raw[j] <= (2 - n)*pi then
              theta[j] = theta_raw[j] + theta_change;
              loadzone[j] = 1;
            else
              theta[j] = theta_raw[j] - theta_change;
              loadzone[j] = 0;
            end if;
          end for;
/*defect block*/
//essential parameters for each defect on race
          for p in 1:nd loop
            if wz[p] == 1 or wz[p] == 2 then
              race[p] = wz[p];
              ball[p] = 0;
            elseif wz[p] == 3 then
              race[p] = 0;
              ball[p] = wz[p];
            end if;
          end for;
          for i in 1:nd loop
            if race[i] == 0 then
              eta_bd[i] = -1;
              eta_d[i] = -1;
              delta_phi_d[i] = -1;
              Hd[i] = -1;
              cd_raw[i] = -1;
              phi_1[i] = -1;
              phi_2[i] = -1;
            else
              sin(0.5*delta_phi_d[i]) = B[i]/(Db + Dp);
//sin unit is rad, delta_phi_d is also in rad
              Hd[i] = 0.5*Db - sqrt((0.5*Db)^2 - (0.5*B[i])^2);
              cd_raw[i] = min(Hd[i], H[i]);
              phi_1[i] = delta_phi_d[i]*lambda[i];
//phi_1 should be in rad
              phi_2[i] = delta_phi_d[i]*(1 - lambda[i]);
              eta_bd[i] = Db/min(L[i], B[i]);
              eta_d[i] = L[i]/B[i];
            end if;
          end for;
//*********** beta for race*****
          for i in 1:nd loop
            if race[i] == 1 then
              fault_start[i] = phi_d[i]/360*2*pi;
              fault_end[i] = delta_phi_d[i] + fault_start[i];
//delta_phi_d [rad]
            elseif race[i] == 2 then
              fault_start[i] = mod(phi_d[i]/360*2*pi + ws*u3, 2*pi);
              fault_end[i] = delta_phi_d[i] + fault_start[i];
            else
              fault_end[i] = -1;
              fault_start[i] = -1;
            end if;
          end for;
          for j in 1:nb loop
            for i in 1:nd loop
              if race[i] == 0 then
                beta_race[j, i] = -1;
                u[j, i] = -1;
                fault_delta_0[j, i] = 0;
              else
                if theta[j] >= fault_start[i] and theta[j] <= fault_end[i] then
                  beta_race[j, i] = 1;
                  u[j, i] = theta[j] - fault_start[i];
//u is in rad
                  fault_delta_0[j, i] = beta_race[j, i]*cd[j, i];
                else
                  beta_race[j, i] = 0;
                  u[j, i] = 0;
                  fault_delta_0[j, i] = 0;
                end if;
              end if;
            end for;
            fault_delta[j] = sum(fault_delta_0[j]);
          end for;
//  for j in 1:nb loop
//    for i in 1:nd loop
//      fault_delta[j] = fault_delta_0[j, i];
//    end for;
//  end for;
//WWWWWWWWWWWWWWWWWW
//********* cd for race********
//**********************
          for i in 1:nd loop
            for j in 1:nb loop
//..1............
              if eta_bd[i] > 50 then
                cd[j, i] = cd_raw[i];
//.....2........
              elseif eta_bd[i] <= 50 and eta_bd[i] > 1 then
                if eta_d[i] <= 1 then
// cd[j, i] = cd_raw[i]*sin(pi/delta_phi_d[i]*u[j, i]);
          cd[j, i] = cd_raw[i] * sin(180 / delta_phi_d[i]  * u[j, i]*180/pi);                //sin use in degree???
                else
                  if u[j, i] > 0 and u[j, i] < phi_1[i] then
                    cd[j, i] = cd_raw[i]*sin(0.5*pi/phi_1[i]*u[j, i]);
                  elseif u[j, i] >= phi_1[i] and u[j, i] < phi_2[i] then
                    cd[j, i] = cd_raw[i];
                  elseif u[j, i] >= phi_2[i] and u[j, i] < delta_phi_d[i] then
//           cd[j, i] = cd_raw[i]*sin(pi/(2*phi_1[i])*u[j, i] + pi/2);
           cd[j, i] = cd_raw[i] * sin((0.5 * pi / phi_1[i] * u[j, i] + pi / 2)*180/pi);
                  else
                    cd[j, i] = 0;
                  end if;
                end if;
//..3.........
              else
//eta_bd<=1
//,,,,1
                if u[j, i] > 0 and u[j, i] < phi_1[i] then
//        cd[j, i] = cd_raw[i]*sin(2*pi/delta_phi_d[i]*u[j, i]);
         cd[j, i] = cd_raw[i] * sin(360 / delta_phi_d[i]  * u[j, i]*180/pi);                //using degree for sine
                elseif u[j, i] >= phi_1[i] and u[j, i] < phi_2[i] then
                  cd[j, i] = cd_raw[i];
                elseif u[j, i] >= phi_2[i] and u[j, i] < delta_phi_d[i] then
// cd[j, i] = cd_raw[i]*sin(2*pi/delta_phi_d[i]*u[j, i] + pi/2);
         cd[j, i] = cd_raw[i] * sin((360 / delta_phi_d[i] * u[j, i] + pi / 2)*180/pi);
                else
                  cd[j, i] = 0;
                end if;
              end if;
            end for;
          end for;
//..................................................
//block 2: sinking depth of each ball with  fault:
          delta_raw = u1*cos(theta).*loadzone + u2*sin(theta).*loadzone .- c - fault_delta;
//.................................................
/*add fault_delta and according to if delta bigger than 0 to remove some deformation values*/
          for j in 1:nb loop
            delta[j] = max(delta_raw[j], 0);
          end for;
//block 3: for contact force
          for j in 1:nb loop
            delta_modi[j] = abs(delta[j])^1.5;
            force_x[j] = kb*cos(theta[j])*delta_modi[j];
            force_y[j] = kb*sin(theta[j])*delta_modi[j];
          end for;
          fx = sum(force_x);
          fy = sum(force_y);
          v_x = der(u1);
          v_y = der(u2);
          acc_x = der(v_x);
          acc_y = der(v_y);
          annotation(
            uses(Modelica(version = "3.2.2")),
            Icon(graphics = {Rectangle(origin = {-1, 11}, fillColor = {255, 255, 127}, fillPattern = FillPattern.Solid, extent = {{-99, 89}, {101, -111}}), Text(origin = {-12, 129}, lineColor = {0, 0, 255}, extent = {{-28, 11}, {28, -11}}, textString = "Outer or Inner", fontName = "Arial", textStyle = {TextStyle.Bold})}, coordinateSystem(initialScale = 0.1)),
            Documentation(info = "<html><head></head><body>according to fault position classify it to raceway defect and rolling elements spall.<div>because the defect initial position on inner race will change with time, it should be different from outer race defect model.</div></body></html>"));
        end Race;

        model Ball
          import Modelica.Constants.pi;
          //part 1
          parameter Integer nb = 9;
          //  parameter Real f = 25 "Hz";
          parameter Real Dp = 39.32e-3 "m";
          parameter Real Db = 7.94e-3 "m";
          parameter Real phi_slip = 0.01 "rad";
          parameter Real mut = 0 "mutation percentage";
          parameter Real kb = 1.89e10 "N/m";
          parameter Real c = 0 "m, bearing clearance";
          parameter Real alpha = 0 "rad, contact angular";
          parameter Integer wz[:] = {3} "1 for outer, 2 for inner, 3 for ball" annotation(
            Dialog(group = "defect properties_ball"));
          parameter Integer k[nd] = {4} "order of each defect ball" annotation(
            Dialog(group = "defect properties_ball"));
          parameter Real w[nd] = {3e-3} "m,width of spall" annotation(
            Dialog(group = "defect properties_ball"));
          parameter Real phi_s_ini[nd] = {0} "rad,spall initial position" annotation(
            Dialog(group = "defect properties_ball"));
          Modelica.Blocks.Interfaces.RealInput u1 annotation(
            Placement(transformation(origin = {-110, 60}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}})));
          Modelica.Blocks.Interfaces.RealInput u2 annotation(
            Placement(transformation(origin = {-106, 0}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-110, -20}, extent = {{-10, -10}, {10, 10}})));
          Modelica.Blocks.Interfaces.RealInput u3 annotation(
            Placement(transformation(origin = {-110, -36}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}})));
          Modelica.Blocks.Interfaces.RealInput f "shaft speed" annotation(
            Placement(transformation(origin = {-74, 28}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-110, 20}, extent = {{-10, -10}, {10, 10}})));
          Modelica.Blocks.Interfaces.RealOutput acc_x annotation(
            Placement(transformation(origin = {70, 62}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}})));
          Modelica.Blocks.Interfaces.RealOutput acc_y annotation(
            Placement(transformation(origin = {70, 24}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 20}, extent = {{-10, -10}, {10, 10}})));
          Modelica.Blocks.Interfaces.RealOutput fx annotation(
            Placement(transformation(origin = {70, -22}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -22}, extent = {{-10, -10}, {10, 10}})));
          Modelica.Blocks.Interfaces.RealOutput fy annotation(
            Placement(transformation(origin = {70, -60}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -62}, extent = {{-10, -10}, {10, 10}})));
        protected
          parameter Integer nd = size(wz, 1) "number of defective balls" annotation(
            Dialog(group = "defect properties_ball"));
          Real Di;
          Real Do;
          Real ws;
          //shaft speed
          Real wc;
          Real theta_change;
          //add inner variables
          //blcok 1
          Real theta_raw[nb];
          Real theta[nb];
          //block 2
          Real delta_raw[nb];
          Real delta[nb];
          //block 3
          Real force_x[nb];
          Real force_y[nb];
          Real delta_modi[nb];
          //block 4 ball defect
          Integer race[nd];
          Integer ball[nd];
          Real cdi[nd];
          Real cdo[nd];
          Real cdr[nd];
          Real Hb1[nd];
          Real Hb2[nd];
          Real phi_s[nd] "[rad]spall angular position";
          Real delta_phi_b[nd];
          Real delta_phi_bo[nd];
          Real delta_phi_bi[nd];
          Real fault_delta[nb];
          Real fault_delta_0[nb, nd];
          Real beta_ball[nb, nd];
          Real cd[nd];
          Real v_x;
          Real v_y;
          //.......................................................................
        equation
//geometric relation
          Do = Dp + Db;
          Di = Dp - Db;
//block 1:for theta
          ws = 2*pi*f;
/*1)wc*/
          wc = (1 - Db/Dp)*ws/2;
/*2)theta_raw for every ball*/
          for j in 1:nb loop
            theta_raw[j] = mod(2*pi*(j - 1)/nb + wc*u3, 2*pi);
          end for;
/*3)how is the abslote angular change caused by slip: depends on mutation percentage and phi_slip*/
          theta_change = mut*0.5*phi_slip;
/*according to if the ball goes into the load zone, modify the theta for each ball*/
          for j in 1:nb loop
            if theta_raw[j] >= pi and theta_raw[j] < 2*pi then
              theta[j] = theta_raw[j] + theta_change;
            else
              theta[j] = theta_raw[j] - theta_change;
            end if;
          end for;
/*block defect*/
//essential parameters for defect on each ball
          for p in 1:nd loop
            if wz[p] == 1 or wz[p] == 2 then
              race[p] = wz[p];
              ball[p] = 0;
            elseif wz[p] == 3 then
              race[p] = 0;
              ball[p] = wz[p];
            end if;
          end for;
          for i in 1:nd loop
            if ball[i] == 0 then
              cdi[i] = -1;
              cdo[i] = -1;
              cdr[i] = -1;
              Hb1[i] = -1;
              Hb2[i] = -1;
              delta_phi_b[i] = -1;
              delta_phi_bi[i] = -1;
              delta_phi_bo[i] = -1;
            else
              cdi[i] = 1/2*(Di - sqrt(Di^2 - w[i]^2));
              cdo[i] = 1/2*(Do - sqrt(Do^2 - w[i]^2));
              cdr[i] = 1/2*(Db - sqrt(Db^2 - w[i]^2));
              Hb1[i] = cdr[i] - cdo[i];
              Hb2[i] = cdr[i] + cdi[i];
              sin(0.5*delta_phi_b[i]/360*2*pi) = w[i]/Db;
              delta_phi_bo[i] = Db/Do*delta_phi_b[i]/360*2*pi;
              delta_phi_bi[i] = Db/Di*delta_phi_b[i]/360*2*pi;
            end if;
          end for;
//*********** beta for  defect ball*****
//for the ball with spall, the spall's position can be determined by:
          for i in 1:nd loop
            if ball[i] == 0 then
              phi_s[i] = -1;
              cd[i] = -1;
            else
              phi_s[i] = mod(2*pi*Dp/2/Db*(1 - (Db/Dp*cos(alpha))^2)*f*u3 + phi_s_ini[i], 2*pi);
              if phi_s[i] > 0 and phi_s[i] < delta_phi_bo[i] then
                cd[i] = Hb1[i];
              elseif phi_s[i] > pi and phi_s[i] < pi + delta_phi_bi[i] then
                cd[i] = Hb2[i];
              else
                cd[i] = 0;
              end if;
            end if;
          end for;
          for j in 1:nb loop
            for i in 1:nd loop
              if ball[i] == 0 then
                beta_ball[j, i] = -1;
                fault_delta_0[j, i] = 0;
              else
                if j == k[i] then
                  beta_ball[j, i] = 1;
                  fault_delta_0[j, i] = beta_ball[j, i]*cd[i];
                else
                  beta_ball[j, i] = 0;
                  fault_delta_0[j, i] = beta_ball[j, i]*cd[i];
                end if;
              end if;
            end for;
            fault_delta[j] = sum(fault_delta_0[j]);
          end for;
//..........................................
//  fault_delta = beta_ball .* cd;
//..................................................
//block 2: for delta
          delta_raw = u1*cos(theta) + u2*sin(theta) .- c - fault_delta;
//.................................................
/*according to if delta bigger than 0 to remove some deformation values*/
          for j in 1:nb loop
            if delta_raw[j] < 0 then
              delta[j] = 0;
            else
              delta[j] = delta_raw[j];
            end if;
          end for;
//block 3: for contact force
          for j in 1:nb loop
            delta_modi[j] = abs(delta[j])^1.5;
            force_x[j] = kb*cos(theta[j])*delta_modi[j];
            force_y[j] = kb*sin(theta[j])*delta_modi[j];
          end for;
          fx = sum(force_x);
          fy = sum(force_y);
          v_x = der(u1);
          v_y = der(u2);
          acc_x = der(v_x);
          acc_y = der(v_y);
          annotation(
            uses(Modelica(version = "3.2.2")),
            Icon(graphics = {Text(origin = {0, 109}, textColor = {0, 0, 255}, extent = {{-28, 11}, {28, -11}}, textString = "BallDefect", fontName = "Arial", textStyle = {TextStyle.Bold}), Rectangle(lineThickness = 0.75, extent = {{-100, 100}, {100, -100}}), Text(origin = {-4, 31}, extent = {{-72, 35}, {72, -35}}, textString = "Defect"), Text(origin = {0, -30}, extent = {{-68, 28}, {68, -28}}, textString = "Ball")}, coordinateSystem(initialScale = 0.1)),
            __OpenModelica_commandLineOptions = "");
        end Ball;
      end DefectModel;
    end Components;
  end TestBearings;

  package DrivingSystem
    model Motor
      import Modelica.Constants.pi;
      parameter Real IM = 0.01 "kgm^2,moment of inertia on motor" annotation(
        Dialog(group = "mechanics rotational"));
      parameter Real CM = 0.1 "Nms" annotation(
        Dialog(group = "mechanics rotational"));
      parameter Real Kt = 0.01 "Nm/An, default Kt=Ke" annotation(
        Dialog(group = "mechanics rotational"));
      parameter Real Ke = 0.01 "V/rad/s, default Kt=Ke" annotation(
        Dialog(group = "electrics"));
      parameter Real R = 1 "Ohm" annotation(
        Dialog(group = "electrics"));
      parameter Real L = 0.5 "H" annotation(
        Dialog(group = "electrics"));
      Real i;
      //  output Real Torque annotation(Dialog(group="output"));
      Real theta;
      //  Real w;
      Modelica.Blocks.Interfaces.RealInput v "supplyvoltage" annotation(
        Placement(visible = true, transformation(origin = {-104, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-124, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealOutput f "angular speed [Hz] of motor rotor" annotation(
        Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealOutput Torque annotation(
        Placement(visible = true, transformation(origin = {10, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {10, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealOutput w annotation(
        Placement(visible = true, transformation(origin = {10, -96}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {10, -118}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    equation
      w = der(theta);
      IM*der(w) + CM*w = Kt*i;
      L*der(i) + R*i = v - Ke*w;
      Torque = Kt*i;
      2*pi*f = w;
      annotation(
        Icon(graphics = {Text(origin = {56, -205}, extent = {{-130, 101}, {34, -7}}, textString = "motor", fontName = "Arial"), Ellipse(fillColor = {170, 255, 127}, fillPattern = FillPattern.Solid, extent = {{-60, 60}, {60, -60}}, endAngle = 360), Line(points = {{-40, -40}, {-30, 50}, {0, -40}, {30, 50}, {40, -40}}, thickness = 0.5)}, coordinateSystem(initialScale = 0.1)));
    end Motor;

    model Shaft
      import Modelica.Constants.pi;
      parameter Real Dp = 39.32e-3 "m" annotation(
        Dialog(group = "Bearing"));
      parameter Real Db = 7.94e-3 "m" annotation(
        Dialog(group = "Bearing"));
      parameter Real G = 79e9 "Pa=N/m^2, shear modulus" annotation(
        Dialog(group = "shaft"));
      parameter Real l = 1 "m" annotation(
        Dialog(group = "shaft"));
      Real D = Dp - Db;
      Real JS = pi*D^4/32 "m^4,torsion constant";
      Real CS = 0.034907*KS "Nms,Damping, proportional to stiffness";
      Real KS = G*JS/l "N/m,Stiffness";
      Real w_in;
      Real w_out;
      Real theta_in;
      Real theta_out;
      Modelica.Blocks.Interfaces.RealInput f_in annotation(
        Placement(visible = true, transformation(origin = {-116, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealOutput f_out annotation(
        Placement(visible = true, transformation(origin = {116, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {116, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealInput u "torque" annotation(
        Placement(visible = true, transformation(origin = {0, 112}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {20, 120}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
    equation
      2*pi*f_in = w_in;
      2*pi*f_out = w_out;
      der(theta_in) = w_in;
      der(theta_out) = w_out;
      u = KS*(theta_in - theta_out) + CS*(w_in - w_out);
      annotation(
        Icon(graphics = {Ellipse(origin = {-90, 0}, fillColor = {255, 255, 255}, extent = {{-10, 40}, {10, -40}}, endAngle = 360), Ellipse(origin = {90, 0}, extent = {{-10, 40}, {10, -40}}, endAngle = 360), Rectangle(pattern = LinePattern.Dot, extent = {{-90, 40}, {90, -40}}), Text(origin = {48, -183}, extent = {{-128, 69}, {32, -9}}, textString = "shaft", fontName = "Arial")}, coordinateSystem(initialScale = 0.1)));
    end Shaft;
  end DrivingSystem;

  package LoadingSystem
    model E_hydraulicsServo
      parameter Real Ap = 15.26e-4 "m^2,piston area";
      parameter Real Vt = 1072e-4 "m^3,cylinder volume";
      parameter Real Mt = 2.5 "kg,piston mass";
      parameter Real Bp = 32e-6 "m^2/s,fluid viscosity";
      parameter Real be = 7e8 "the volume elastic modulus of hydraulic oil";
      parameter Real Kp = 1 "A/V" annotation(
        dialog(group = "Amplifier"));
      Modelica.Blocks.Interfaces.RealInput Ue annotation(
        Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      Modelica.Blocks.Math.Gain Amp(k = Kp) annotation(
        Placement(visible = true, transformation(origin = {-72, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Continuous.SecondOrder valve_2nd(D = 0.7, k = 0.056, w = 500) annotation(
        Placement(visible = true, transformation(origin = {-38, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Continuous.SecondOrder Hydrau_2nd(D = 0.2, k = 655.3, w = 156, yd(fixed = true)) annotation(
        Placement(visible = true, transformation(origin = {14, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealOutput y1 "xp" annotation(
        Placement(visible = true, transformation(origin = {122, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {130, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealOutput y2 "vp" annotation(
        Placement(visible = true, transformation(origin = {118, -42}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {70, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Continuous.Der der1 annotation(
        Placement(visible = true, transformation(origin = {82, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealOutput y3 "accp" annotation(
        Placement(visible = true, transformation(origin = {118, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {70, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Continuous.Integrator integrator2 annotation(
        Placement(visible = true, transformation(origin = {48, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealOutput i annotation(
        Placement(visible = true, transformation(origin = {-50, 94}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-70, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealOutput qL annotation(
        Placement(visible = true, transformation(origin = {-10, 94}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {20, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Continuous.Der der11 annotation(
        Placement(visible = true, transformation(origin = {64, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      parameter Real KL = 538509 annotation(
        Dialog(tab = "Advanced"));
      parameter Real wL = 11.35 annotation(
        Dialog(tab = "Advanced"));
      parameter Real qmax = 1.25e-3 annotation(
        Dialog(tab = "Advanced"));
      parameter Real Imax = 10e-3 annotation(
        Dialog(tab = "Advanced"));
      Real pL;
      Real FL;
      Real xv;
      Real Kq;
      Modelica.Blocks.Interfaces.RealOutput y4 "FL" annotation(
        Placement(visible = true, transformation(origin = {-46, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {150, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    equation
      connect(valve_2nd.y, Hydrau_2nd.u) annotation(
        Line(points = {{-26, 0}, {2, 0}, {2, 0}, {2, 0}}, color = {0, 0, 127}));
//dynamics for load force
      Kq = qmax/Imax;
      Ap*pL = Mt*y3 + Bp*y2 + FL;
      qL = Kq*xv;
      qL = Ap*der(xv) + Vt/(4*be)*der(pL);
      y4 = FL;
      connect(integrator2.y, y1) annotation(
        Line(points = {{60, 0}, {66, 0}, {66, 60}, {122, 60}, {122, 60}}, color = {0, 0, 127}));
      connect(integrator2.y, der1.u) annotation(
        Line(points = {{60, 0}, {70, 0}, {70, 0}, {70, 0}}, color = {0, 0, 127}));
      connect(Hydrau_2nd.y, integrator2.u) annotation(
        Line(points = {{26, 0}, {36, 0}, {36, 0}, {36, 0}}, color = {0, 0, 127}));
      connect(der11.y, y3) annotation(
        Line(points = {{76, -80}, {110, -80}, {110, -80}, {118, -80}}, color = {0, 0, 127}));
      connect(y2, der11.u) annotation(
        Line(points = {{118, -42}, {26, -42}, {26, -80}, {52, -80}, {52, -80}}, color = {0, 0, 127}));
      connect(der1.y, y2) annotation(
        Line(points = {{93, 0}, {104.5, 0}, {104.5, -42}, {118, -42}}, color = {0, 0, 127}));
      connect(valve_2nd.y, qL) annotation(
        Line(points = {{-26, 0}, {-18, 0}, {-18, 94}, {-10, 94}}, color = {0, 0, 127}));
      connect(Amp.y, i) annotation(
        Line(points = {{-60, 0}, {-58, 0}, {-58, 94}, {-50, 94}}, color = {0, 0, 127}));
      connect(Amp.y, valve_2nd.u) annotation(
        Line(points = {{-60, 0}, {-50, 0}}, color = {0, 0, 127}));
      connect(Ue, Amp.u) annotation(
        Line(points = {{-120, 0}, {-84, 0}, {-84, 0}, {-84, 0}}, color = {0, 0, 127}));
      annotation(
        Diagram(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(origin = {-59, -41}, extent = {{-21, 19}, {21, -19}}), Line(origin = {-55.81, 28.19}, points = {{35.8085, 63.8097}, {-30.1915, 21.8097}, {-36.1915, -64.1903}, {-24.1915, -64.1903}}, smooth = Smooth.Bezier), Line(origin = {37.9, 11.9}, points = {{76.0996, 48.0996}, {-31.9004, 22.0996}, {-55.9004, -45.9004}, {-75.9004, -45.9004}}, smooth = Smooth.Bezier), Polygon(origin = {-82, -36}, points = {{-2, 2}, {2, 0}, {-2, -2}, {-2, 2}}), Polygon(origin = {-36, -34}, rotation = 180, points = {{-2, 2}, {2, 0}, {-2, -2}, {-2, 2}}), Line(origin = {-63, -70}, points = {{-7, 10}, {-7, -10}, {7, -10}})}),
        Icon(graphics = {Text(origin = {3, -115}, extent = {{-45, 7}, {45, -7}}, textString = "E-hydraulics Servo", fontName = "Arial"), Rectangle(origin = {2, 52}, extent = {{-42, 24}, {30, -12}}), Rectangle(origin = {-10, 68}, extent = {{18, 8}, {42, -28}}), Rectangle(origin = {-70, 76}, extent = {{12, 18}, {30, -20}}), Rectangle(origin = {-60, 86}, extent = {{2, 6}, {20, -18}}), Line(origin = {-44.96, 86.02}, points = {{4.95589, 1.98414}, {2.95589, -6.01586}, {0.955893, 5.98414}, {-1.04411, -6.01586}, {-3.04411, 5.98414}, {-5.04411, -6.01586}}, thickness = 0.5), Line(origin = {-50, 80}, points = {{0, 12}, {0, -12}}, thickness = 0.5), Polygon(origin = {-50, 74}, fillPattern = FillPattern.Solid, points = {{-2, 2}, {2, 2}, {0, -6}, {-2, 2}}), Polygon(origin = {28, 48}, fillPattern = FillPattern.Solid, points = {{-2, 2}, {2, 2}, {0, -6}, {-2, 2}}), Line(origin = {27.5777, 67.6411}, points = {{0, 8}, {0, -18}}, thickness = 0.5), Polygon(origin = {16, 70}, rotation = 180, fillPattern = FillPattern.Solid, points = {{-2, 2}, {2, 2}, {0, -6}, {-2, 2}}), Line(origin = {16.299, 50.634}, points = {{0, 20}, {0, -8}}, thickness = 0.5), Rectangle(origin = {2, 54}, extent = {{-42, 24}, {30, -12}}), Rectangle(origin = {-58, 70}, extent = {{18, 8}, {42, -28}}), Rectangle(origin = {-17, -21}, extent = {{-75, 17}, {63, -75}}), Rectangle(origin = {-20, -21}, extent = {{-66, 13}, {66, -71}}), Rectangle(origin = {-43, -55}, fillColor = {0, 170, 255}, fillPattern = FillPattern.Solid, extent = {{57, 47}, {-43, -37}}), Rectangle(origin = {16, -51}, extent = {{-2, 43}, {2, -41}}), Rectangle(origin = {64, -51}, extent = {{-46, 7}, {46, -7}}), Polygon(origin = {-28, 26}, fillPattern = FillPattern.Solid, points = {{-2, 2}, {2, 2}, {0, -6}, {-2, 2}}), Line(origin = {-28.0784, 36.6557}, points = {{0, 2}, {0, -12}}, thickness = 0.5)}),
        Documentation(info = "<html><head></head><body>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><!--StartFragment--><span style=\" font-family:'Courier New'; font-size:12pt; color:#008b00;\">Amplifier-Valve-Cylinder,Ue-Delta i-qL-xp</span><!--EndFragment--></pre></body></html>"));
    end E_hydraulicsServo;
  end LoadingSystem;

  type DefectType = enumeration(RaceWay "Defect(s) on raceway", Ball "Defect on rolling element(s)", Healthy "No defect");
  annotation(
    uses(Modelica(version = "4.0.0")));
end BearingLibrary;
