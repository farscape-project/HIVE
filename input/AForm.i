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
  [curlcurlA_coil_vacuum]
    type = CurlCurlField
    variable = A
    coeff = 1
    block = 'coil vacuum_region'
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
    block = target
  []
  [P]
    type = JouleHeatingAux
    variable = P
    electric_field = E
    execute_on = timestep_end
    block = target
  []
[]

[Materials]
  [copper]
    type = GenericConstantMaterial
    prop_names = electrical_conductivity
    prop_values = 5.96e7
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
  num_steps = 1
[]

[Outputs]
  exodus = true
[]

[MultiApps]
  [VPoisson]
    type = FullSolveMultiApp
    input_files = VPoisson.i
    execute_on = initial
  []
[]

[Transfers]
  [pull_potential]
    type = MultiAppCopyTransfer

    # Transfer from the sub-app to this app
    from_multi_app = VPoisson

    # The name of the variable in the sub-app
    source_variable = V

    # The name of the auxiliary variable in this app
    variable = V
  []
[]
