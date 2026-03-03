#pragma once

#include "CurlCurlField.h"

/**
 * Curl-curl field multiplied by a material
 */
class MatCurlCurlField : public CurlCurlField
{
public:
  static InputParameters validParams();

  MatCurlCurlField(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual();
  virtual Real computeQpJacobian();

  /// The material the field is multiplied with
  const MaterialProperty<Real> & _coeff;
};
