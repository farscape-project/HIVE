[Mesh]
  type = FileMesh
  file = ../mesh/vac_meshed_oval_coil_and_solid_target.e
  second_order = true
[]

[Variables]
  [T]
    family = LAGRANGE
    order = SECOND
    initial_condition = 298
  []
[]

[AuxVariables]
  [P]
    family = MONOMIAL
    order = CONSTANT
  []
[]

[Kernels]

 active = 'HeatConduction TimeDerivative HeatSource'

  [HeatConduction]
    type = HeatConduction
    variable = T
  #  block = 'target'
  []

  [TimeDerivative]
    type = TimeDerivative
    variable = T
  #  block = 'target'
  []

  [HeatSource]
    type = CoupledForce
    variable = T
    v = P
   # block = 'target'
  []

  [null]
    type = NullKernel
    variable = T
    block = 'coil vacuum_region'
  []
[]


[Materials]
  [thermal]
    type = HeatConductionMaterial
    thermal_conductivity = 1.0
  []
[]


[BCs]
  [temp_bc]
    type = DirichletBC
    variable = T
    boundary = 'coil_in coil_out terminal_face'
    value = 298
  []
[]

[Executioner]
  type = Transient
  solve_type = LINEAR
  petsc_options_iname = '-pc_type -ksp_rtol'
  petsc_options_value = 'hypre    1e-12'
  start_time = 0.0
  end_time = 0.5
  dt = 0.05
[]

[MultiApps]
  [AFormulation]
    type = TransientMultiApp
    input_files = AFormulation.i
    execute_on = timestep_begin
  []
[]

[Transfers]
  [pull_potential]
    type = MultiAppCopyTransfer

    # Transfer from the sub-app to this app
    from_multi_app = AFormulation

    # The name of the variable in the sub-app
    source_variable = P

    # The name of the auxiliary variable in this app
    variable = P
  []
[]