//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "CoupledGrad.h"
#include "Function.h"
#include "Assembly.h"

registerMooseObject("hiveApp", CoupledGrad);

InputParameters
CoupledGrad::validParams()
{
  InputParameters params = VectorKernel::validParams();
  params.addClassDescription("Takes the gradient of a scalar field, optionally "
                             "scaled by a constant scalar coefficient.");
  params.addRequiredCoupledVar("coupled_scalar_variable", "The scalar field");
  params.addParam<FunctionName>("function", "1", "A scalar function to scale the potential by");
  return params;
}

CoupledGrad::CoupledGrad(const InputParameters & parameters)
  : VectorKernel(parameters),
    _p_var(*getVar("coupled_scalar_variable", 0)),
    _p_var_num(coupled("coupled_scalar_variable")),
    _grad_p(coupledGradient("coupled_scalar_variable")),
    _grad_phi(_assembly.gradPhi(_p_var)),
    _function(getFunction("function"))
{
}

Real
CoupledGrad::computeQpResidual()
{
  return _function.value(_t, _q_point[_qp]) * _grad_p[_qp] * _test[_i][_qp];
}

Real
CoupledGrad::computeQpOffDiagJacobian(unsigned jvar)
{
  if (_p_var_num == jvar)
    return _function.value(_t, _q_point[_qp]) * _grad_phi[_j][_qp] * _test[_i][_qp];

  return 0.0;
}