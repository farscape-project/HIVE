//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "VectorTimeDerivativeAux.h"

registerMooseObject("hiveApp", VectorTimeDerivativeAux);

InputParameters
VectorTimeDerivativeAux::validParams()
{
  InputParameters params = VectorAuxKernel::validParams();
  params.addClassDescription("Computes the time derivative of a vector field.");
  params.addCoupledVar("vector_variable", "The vector variable");
  return params;
}

VectorTimeDerivativeAux::VectorTimeDerivativeAux(const InputParameters & parameters)
  : VectorAuxKernel(parameters),
    _v_var(*getVectorVar("vector_variable", 0)),
    _vector_variable(coupledVectorValue("vector_variable")),
    _vector_variable_old(_v_var.slnOld()),
    _conductivity(getGenericMaterialProperty<Real, false>("electrical_conductivity"))
{
}

RealVectorValue
VectorTimeDerivativeAux::computeValue()
{
  return -_conductivity[_qp] * (_vector_variable[_qp] - _vector_variable_old[_qp]) / _dt;
}
