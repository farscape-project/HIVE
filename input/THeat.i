!include Parameters.i

[Mesh]
  type = FileMesh
  file = ../mesh/vac_oval_coil_solid_target_fine.e
  second_order = true
  parallel_type = distributed
  uniform_refine = 1
[]

[Variables]
  [T]
    family = LAGRANGE
    order = FIRST
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

[Materials]
  [steel]
    type = GenericConstantMaterial
    prop_names =  'thermal_conductivity   specific_heat     density'
    prop_values = '${steel_tconductivity} ${steel_capacity} ${steel_density}'
    block = 'coil target'
  []
  [vacuum]
    type = GenericConstantMaterial
    prop_names =  'thermal_conductivity    specific_heat      density'
    prop_values = '${vacuum_tconductivity} ${vacuum_capacity} ${vacuum_density}'
    block = vacuum_region
  []
[]

[BCs]
  [plane]
    type = DirichletBC
    variable = T
    boundary = 'coil_in coil_out terminal_plane'
    value = ${room_temperature}
  []
[]

[Postprocessors]
  [P(total){W}]
    type = ElementIntegralVariablePostprocessor
    variable = P
    block = target
  []
  [P(Max){W.m-3}]
    type = ElementExtremeValue
    variable = P
    block = target
  []
  [T(average){K}]
    type = ElementAverageValue
    variable = T
    block = target
  []
  [T(Max){K}]
    type = NodalExtremeValue
    variable = T
    block = target
  []
[]

[Executioner]
  type = Transient
  solve_type = LINEAR
  petsc_options_iname = '-pc_type -ksp_rtol'
  petsc_options_value = 'hypre    1e-12'
  start_time = 0.0
  end_time = ${end_t}
  dt = ${delta_t}
[]

[Outputs]
  exodus = ${visualization}
  csv = true
[]

[MultiApps]
  [AForm]
    type = TransientMultiApp
    input_files = AForm.i
    execute_on = timestep_begin
    clone_parent_mesh = true
  []
[]

[Transfers]
  [pull_power]
    type = MultiAppCopyTransfer
    from_multi_app = AForm
    source_variable = P
    variable = P
  []
[]
