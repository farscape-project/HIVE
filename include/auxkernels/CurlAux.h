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

class CurlAux : public VectorAuxKernel
{
public:
  static InputParameters validParams();

  CurlAux(const InputParameters & parameters);

protected:
  virtual RealVectorValue computeValue() override;

  // curl of the coupled vector variable
  const VectorVariableValue & _coupled_vector_variable_curl;

  /// scalar coefficient
  Real _coeff;
};
