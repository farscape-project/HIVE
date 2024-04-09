//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "CurlAux.h"

registerMooseObject("hiveApp", CurlAux);

InputParameters
CurlAux::validParams()
{
  InputParameters params = VectorAuxKernel::validParams();
  params.addClassDescription("Returns the curl of the specified vector variable, optionally "
                             "scaled by a constant scalar coefficient, as an auxiliary vector "
                             "variable.");
  params.addCoupledVar("coupled_vector_variable", "The vector field");
  params.addParam<Real>("coeff", 1, "The constant coefficient");
  return params;
}

CurlAux::CurlAux(const InputParameters & parameters)
  : VectorAuxKernel(parameters),
    _coupled_vector_variable_curl(coupledCurl("coupled_vector_variable")),
    _coeff(getParam<Real>("coeff"))
{
}

RealVectorValue
CurlAux::computeValue()
{
  return _coeff * _coupled_vector_variable_curl[_qp];
}
