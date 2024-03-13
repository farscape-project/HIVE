//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "CoefVectorTimeDerivative.h"

registerMooseObject("MooseApp", CoefVectorTimeDerivative);

InputParameters
CoefVectorTimeDerivative::validParams()
{
  InputParameters params = VectorTimeDerivative::validParams();
  params.addParam<Real>("Coefficient", 1, "The coefficient for the time derivative kernel");
  return params;
}

CoefVectorTimeDerivative::CoefVectorTimeDerivative(const InputParameters & parameters)
  : VectorTimeDerivative(parameters), _coef(getParam<Real>("Coefficient"))
{
}

Real
CoefVectorTimeDerivative::computeQpResidual()
{
  return _coef * VectorTimeDerivative::computeQpResidual();
}

Real
CoefVectorTimeDerivative::computeQpJacobian()
{
  return _coef * VectorTimeDerivative::computeQpJacobian();
}
