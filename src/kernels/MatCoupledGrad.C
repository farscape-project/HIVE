#include "MatCoupledGrad.h"
#include "Function.h"
#include "Assembly.h"

registerMooseObject("hiveApp", MatCoupledGrad);

InputParameters
MatCoupledGrad::validParams()
{
  InputParameters params = VectorKernel::validParams();
  params.addClassDescription("Takes the gradient of a scalar field, optionally "
                             "scaled by a constant scalar coefficient.");
  params.addRequiredCoupledVar("coupled_scalar_variable", "The scalar field");
  params.addRequiredParam<MaterialPropertyName>(
      "material",
      "The name of the material property that will be multiplied by the function.");
  params.addParam<FunctionName>("function", "1", "A scalar function to scale the potential by");
  return params;
}

MatCoupledGrad::MatCoupledGrad(const InputParameters & parameters)
  : VectorKernel(parameters),
    _p_var(*getVar("coupled_scalar_variable", 0)),
    _p_var_num(coupled("coupled_scalar_variable")),
    _grad_p(coupledGradient("coupled_scalar_variable")),
    _grad_phi(_assembly.gradPhi(_p_var)),
    _function(getFunction("function")),
    _material(getMaterialProperty<Real>("material"))
{
}

Real
MatCoupledGrad::computeQpResidual()
{
  return _material[_qp] * _function.value(_t, _q_point[_qp]) * _grad_p[_qp] * _test[_i][_qp];
}

Real
MatCoupledGrad::computeQpOffDiagJacobian(unsigned jvar)
{
  if (_p_var_num == jvar)
    return _material[_qp] * _function.value(_t, _q_point[_qp]) * _grad_phi[_j][_qp] * _test[_i][_qp];

  return 0.0;
}
