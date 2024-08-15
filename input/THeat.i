!include Parameters.i

[Mesh]
  type = FileMesh
  file = ../mesh/vac_oval_coil_solid_target.e
  second_order = true
[]

[Variables]
  [T]
    family = LAGRANGE
    order = SECOND
    initial_condition = ${room_temperature}
  []
[]

[AuxVariables]
  [P]
    family = MONOMIAL
    order = CONSTANT
  []
[]

[Kernels]
  [HeatConduction]
    type = HeatConduction
    variable = T
  []
  [TimeDerivative]
    type = HeatConductionTimeDerivative
    variable = T
  []
  [HeatSource]
    type = CoupledForce
    variable = T
    v = P
  []
[]

[Functions]
  [ss316l-sh-func]
    type = PiecewiseLinear
    data_file = ../matprops/steel_316L_specific_heat_capacity.csv
    format = columns
  []
  [ss316l-tc-func]
    type = PiecewiseLinear
    data_file = ../matprops/steel_316L_thermal_conductivity.csv
    format = columns
  []
  [ss316l-density-func]
    type = PiecewiseLinear
    data_file = ../matprops/steel_316L_density.csv
    format = columns
  []
  [water-htc-func]
    type = PiecewiseLinear
    data_file = ../matprops/water_htc.csv
    format = columns
  []
[]

[Materials]
  [ss316l-density]
    type = CoupledValueFunctionMaterial
    v = T
    prop_name = density
    function = ss316l-density-func
    block = "coil target"
  []
  [ss316l-thermal]
    type = HeatConductionMaterial
    temp = T
    specific_heat_temperature_function = ss316l-sh-func
    thermal_conductivity_temperature_function = ss316l-tc-func
    block = "coil target"
  []
  [vacuum-thermal]
    type = HeatConductionMaterial
    temp = T
    specific_heat = ${vacuum_capacity}
    thermal_conductivity = ${vacuum_tconductivity}
    block = "vacuum_region"
  []
  [coolant_heat_transfer_coefficient]
    type = CoupledValueFunctionMaterial
    v = T
    prop_name = heat_transfer_coefficient
    function = water-htc-func
  []
  [vacuum]
    type = GenericConstantMaterial
    prop_names =  'density'
    prop_values = '${vacuum_density}'
    block = vacuum_region
  []
[]

[BCs]
  [plane]
    type = DirichletBC
    variable = T
    boundary = 'coil_in coil_out'
    value = ${room_temperature}
  []
  [heat_flux_out]
    type = ConvectiveHeatFluxBC
    variable = T
    boundary = 'inner_pipe'
    T_infinity = ${coolant_bulk_temp}
    heat_transfer_coefficient = heat_transfer_coefficient
  []
[]

[Executioner]
  type = Transient
  petsc_options_iname = -pc_type
  petsc_options_value = hypre
  start_time = 0.0
  end_time = ${end_t_temp}
  dt = ${delta_t_temp}
  nl_abs_tol = 1e-6
  nl_rel_tol = 1e-8
  l_tol = 1e-8
[]

[Postprocessors]
  [max-T]
    type = NodalExtremeValue
    variable = T
  []
[]

[Outputs]
  exodus = true
  print_linear_residuals=false
  csv = true
[]

[MultiApps]
  [AForm]
    type = FullSolveMultiApp
    input_files = AForm.i
    execute_on = initial
  []
[]

[Transfers]
  [pull_potential]
    type = MultiAppCopyTransfer
    from_multi_app = AForm
    source_variable = P
    variable = P
  []
[]
