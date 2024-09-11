!include Parameters.i

[Mesh]
  type = CoupledMFEMMesh
  file = ../mesh/vac_oval_coil_solid_target_coarse.e
  dim = 3
[]

[Problem]
  type = MFEMProblem
[]

[Formulation]
  type = AFormulation
  magnetic_vector_potential_name = magnetic_vector_potential
  magnetic_reluctivity_name = magnetic_reluctivity
  magnetic_permeability_name = magnetic_permeability
  electric_conductivity_name = electrical_conductivity
  current_density_name = current_density
  magnetic_flux_density_name = magnetic_flux_density
  electric_field_name = electric_field
  joule_heating_density_name = P
[]

[FESpaces]
  [H1FESpace]
    type = MFEMFESpace
    fespace_type = H1
    order = FIRST
  []
  [HCurlFESpace]
    type = MFEMFESpace
    fespace_type = ND
    order = FIRST
  []
  [HDivFESpace]
    type = MFEMFESpace
    fespace_type = RT
    order = CONSTANT
  []
  [L2FESpace]
    type = MFEMFESpace
    fespace_type = L2
    order = CONSTANT
  []
[]

[AuxVariables]
  [magnetic_vector_potential]
    type = MFEMVariable
    fespace = HCurlFESpace
  []
  [electric_field]
    type = MFEMVariable
    fespace = HCurlFESpace
  []
  [magnetic_flux_density]
    type = MFEMVariable
    fespace = HDivFESpace
  []
  [current_density]
    type = MFEMVariable
    fespace = HDivFESpace
  []

  [source_current_density]
    type = MFEMVariable
    fespace = HDivFESpace
  []
  [source_electric_field]
    type = MFEMVariable
    fespace = HCurlFESpace
  []
  [source_electric_potential]
    type = MFEMVariable
    fespace = H1FESpace
  []
  [P]
    family = MONOMIAL
    order = CONSTANT
    initial_condition = 0.0
  []
[]

[BCs]
  [tangential_E_bc]
    type = MFEMVectorDirichletBC
    variable = dmagnetic_vector_potential_dt
    boundary = '1 2 3'
    vector_coefficient = ZeroVectorCoef
  []
[]

[Materials]
  [coil]
    type = MFEMConductor
    electrical_conductivity_coeff = VacuumEConductivity
    electric_permittivity_coeff = VacuumPermittivity
    magnetic_permeability_coeff = TargetPermeability
    block = 1
  []
  [target]
    type = MFEMConductor
    electrical_conductivity_coeff = TargetEConductivity
    electric_permittivity_coeff = VacuumPermittivity
    magnetic_permeability_coeff = TargetPermeability
    block = 2
  []
  [vacuum]
    type = MFEMConductor
    electrical_conductivity_coeff = VacuumEConductivity
    electric_permittivity_coeff = VacuumPermittivity
    magnetic_permeability_coeff = VacuumPermeability
    block = 3
  []
[]

[VectorCoefficients]
  [ZeroVectorCoef]
    type = MFEMVectorConstantCoefficient
    value_x = 0.0
    value_y = 0.0
    value_z = 0.0
  []
[]

[Functions]
  [current_magnitude]
    type = ParsedFunction
    value = 1000*sin(2.0*pi*1e5*t)
  []
[]

[Coefficients]
  [CoilEConductivity]
    type = MFEMConstantCoefficient
    value = ${copper_econductivity}
  []
  [VacuumEConductivity]
    type = MFEMConstantCoefficient
    value = ${vacuum_econductivity}
  []
  [VacuumPermeability]
    type = MFEMConstantCoefficient
    value = ${vacuum_permeability}
  []
  [VacuumPermittivity]
    type = MFEMConstantCoefficient
    value = 0.0
  []
  [TargetEConductivity]
    type = MFEMConstantCoefficient
    value = ${copper_econductivity}
  []
  [TargetPermeability]
    type = MFEMConstantCoefficient
    value = ${copper_permeability}
  []
  [CurrentCoef]
    type = MFEMFunctionCoefficient
    function = current_magnitude
  []
[]

[Sources]
  [SourcePotential]
    type = MFEMOpenCoilSource
    total_current_coef = CurrentCoef
    source_current_density_gridfunction = source_current_density
    source_electric_field_gridfunction = source_electric_field
    source_potential_gridfunction = source_electric_potential
    coil_in_boundary = 1
    coil_out_boundary = 2
    block = 1

    l_tol = 1e-16
    l_abs_tol = 1e-16
    l_max_its = 300
    print_level = 1
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
[]

[Executioner]
  type = Transient
  start_time = 0.0
  end_time = ${end_t}
  dt = ${delta_t}
  l_tol = 1e-16
  l_max_its = 1000
[]

[Outputs]
  [ParaViewDataCollection]
    type = MFEMParaViewDataCollection
    file_base = OutputData/AForm_t
  []
[]
