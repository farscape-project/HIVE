//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#pragma once

#include "AuxKernel.h"

class VectorTimeDerivativeAux : public VectorAuxKernel
{
public:
  static InputParameters validParams();

  VectorTimeDerivativeAux(const InputParameters & parameters);

protected:
  virtual RealVectorValue computeValue() override;

  // time derivative of the coupled vector variable
  const VectorVariableValue & _coupled_vector_variable_dot;

  /// scalar coefficient
  Real _coeff;
};
