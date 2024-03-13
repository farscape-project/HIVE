!include Constants.i

[Mesh]
  type = FileMesh
  file = ../mesh/vac_meshed_oval_coil_and_solid_target.e
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

[Materials]
  [copper]
    type = GenericConstantMaterial
    prop_names =  'thermal_conductivity    specific_heat      density'
    prop_values = '${copper_tconductivity} ${copper_capacity} ${copper_density}'
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
    boundary = 'coil_in coil_out terminal_face'
    value = ${room_temperature}
  []
[]

[Executioner]
  type = Transient
  solve_type = LINEAR
  petsc_options_iname = -pc_type
  petsc_options_value = hypre
  start_time = 0.0
  end_time = 0.5
  dt = 0.05
[]

[Outputs]
  exodus = true
[]

[MultiApps]
  [AForm]
    type = TransientMultiApp
    input_files = AForm.i
    execute_on = timestep_begin
  []
[]

[Transfers]
  [pull_potential]
    type = MultiAppCopyTransfer

    # Transfer from the sub-app to this app
    from_multi_app = AForm

    # The name of the variable in the sub-app
    source_variable = P

    # The name of the auxiliary variable in this app
    variable = P
  []
[]
