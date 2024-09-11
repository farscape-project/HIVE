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
  type = ComplexAFormulation
  magnetic_vector_potential_name = magnetic_vector_potential
  magnetic_vector_potential_re_name = magnetic_vector_potential_re
  magnetic_vector_potential_im_name = magnetic_vector_potential_im
  frequency_name = frequency
  magnetic_reluctivity_name = magnetic_reluctivity
  magnetic_permeability_name = magnetic_permeability
  electric_conductivity_name = electrical_conductivity
  dielectric_permittivity_name = dielectric_permittivity

  electric_field_re_name = electric_field_re
  electric_field_im_name = electric_field_im
  current_density_re_name = current_density_re
  current_density_im_name = current_density_im
  magnetic_flux_density_re_name = magnetic_flux_density_re
  magnetic_flux_density_im_name = magnetic_flux_density_im
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
  [magnetic_vector_potential_re]
    type = MFEMVariable
    fespace = HCurlFESpace
  []
  [magnetic_vector_potential_im]
    type = MFEMVariable
    fespace = HCurlFESpace
  []
  [electric_field_re]
    type = MFEMVariable
    fespace = HCurlFESpace
  []
  [electric_field_im]
    type = MFEMVariable
    fespace = HCurlFESpace
  []
  [magnetic_flux_density_re]
    type = MFEMVariable
    fespace = HDivFESpace
  []
  [magnetic_flux_density_im]
    type = MFEMVariable
    fespace = HDivFESpace
  []
  [current_density_re]
    type = MFEMVariable
    fespace = HDivFESpace
  []
  [current_density_im]
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
    type = MFEMComplexVectorDirichletBC
    variable = magnetic_vector_potential
    boundary = '1 2 3'
    real_vector_coefficient = ZeroVectorCoef
    imag_vector_coefficient = ZeroVectorCoef
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
  [CurrentMagnitude]
    type = MFEMConstantCoefficient
    value = 1000
  []
  [frequency]
    type = MFEMConstantCoefficient
    value = 1e5
  []
[]

[Sources]
  [SourcePotential]
    type = MFEMOpenCoilSource
    total_current_coef = CurrentMagnitude
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
  type = Steady
[]

[Outputs]
  [ParaViewDataCollection]
    type = MFEMParaViewDataCollection
    file_base = OutputData/AForm_w
  []
[]
