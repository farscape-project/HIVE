[Mesh]
  type = FileMesh
  file = ../mesh/vac_meshed_oval_coil_and_solid_target.e
  second_order = true
[]

[Variables]
  [A]
    family = NEDELEC_ONE
    order = FIRST
  []
[]

[AuxVariables]
  [V]
    family = LAGRANGE
    order = SECOND
  []
  [E]
    family = NEDELEC_ONE
    order = FIRST
  []
  [P]
    family = MONOMIAL
    order = CONSTANT
  []
[]

[Kernels]
  [curlcurlA_target]
    type = CurlCurlField
    variable = A
    coeff = 1.68e-8
    block = target
  []
  [curlcurlA_air_coil]
    type = CurlCurlField
    variable = A
    coeff = 1
    block = 'vacuum_region coil'
  []
  [dAdt]
    type = VectorTimeDerivative
    variable = A
  []
  [gradV]
    type = CoupledGrad
    variable = A
    coupled_scalar_variable = V
    function = 5*(1-cos(2*pi/.5*t))
    block = coil
  []
[]

[AuxKernels]
  [E]
    type = VectorTimeDerivativeAux
    variable = E
    vector_variable = A
    execute_on = timestep_end
  []
  [P]
    type = JouleHeatingAux
    variable = P
    electric_field = E
    execute_on = timestep_end
  []
[]

[Materials]
  [copper]
    type = GenericConstantMaterial
    prop_names = electrical_conductivity
    prop_values = 1
  []
[]

[BCs]
  [plane]
    type = VectorCurlPenaltyDirichletBC
    variable = A
    boundary = 'terminal_face coil_in coil_out'
    penalty = 1e8
  []
[]

[Executioner]
  type = Transient
  solve_type = LINEAR
  petsc_options_iname = -pc_type
  petsc_options_value = lu
#  start_time = 0.0
 # end_time = 0.5
  num_steps = 1
  dt = 0.05
[]

[Outputs]
  exodus = true
[]

[MultiApps]
  [VCoil]
    type = FullSolveMultiApp
    input_files = VCoil.i
    execute_on = initial
  []
[]

[Transfers]
  [pull_potential]
    type = MultiAppCopyTransfer

    # Transfer from the sub-app to this app
    from_multi_app = VCoil

    # The name of the variable in the sub-app
    source_variable = V

    # The name of the auxiliary variable in this app
    variable = V
  []
[]
