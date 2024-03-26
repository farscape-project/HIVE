!include Parameters.i

[GlobalParams]
  initial_p = ${outlet_pressure}
  initial_vel = 0.
  initial_T = ${inlet_temp}

  closures = simple_closures
[]

[FluidProperties]
  [water]
    type = SimpleFluidProperties
  []
[]

[Closures]
  [simple_closures]
    type = Closures1PhaseSimple
  []
[]

[Components]
  [pipe1]
    type = FlowChannel1Phase
    position = '0.0 -0.075 0'
    orientation = '0 1 0'
    length = ${innerpipe_len}
    n_elems = 50

    A   = ${innerpipe_area}
    D_h = ${innerpipe_diameter}
    f = 0.01 # friction factor

    fp = water # fluid properties
  []
  
#   [hxconn]
#     type = HeatTransferFromExternalAppHeatFlux1Phase
#     flow_channel = pipe1
#     Hw = water-htc-function
#     P_hf = ${fparse pi*core_dia}
#   []

  [inlet]
    type = InletVelocityTemperature1Phase
    input = 'pipe1:in'
    vel = ${fparse vol_flowrate / innerpipe_area}
    T = ${inlet_temp}
  []

  [outlet]
    type = Outlet1Phase
    input = 'pipe1:out'
    p = ${outlet_pressure}
  []
[]

[Executioner]
  type="Transient"
  start_time="0"
  end_time = ${end_t}
  dtmin="1e-09"
  solve_type="NEWTON"
  line_search="basic"
  nl_abs_tol="1e-05"
  nl_rel_tol="1e-07"
  nl_max_its="10"
  l_max_its="100"

  petsc_options_iname = '-pc_type'
  petsc_options_value = ' lu'

  [./TimeStepper]
    type = ConstantDT
    dt = 0.01
    cutback_factor_at_failure = 0.1
  [../]
[]

[Outputs]
  vtk = true
[]