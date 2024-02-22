//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html
#include "hiveTestApp.h"
#include "hiveApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "MooseSyntax.h"

InputParameters
hiveTestApp::validParams()
{
  InputParameters params = hiveApp::validParams();
  params.set<bool>("use_legacy_material_output") = false;
  return params;
}

hiveTestApp::hiveTestApp(InputParameters parameters) : MooseApp(parameters)
{
  hiveTestApp::registerAll(
      _factory, _action_factory, _syntax, getParam<bool>("allow_test_objects"));
}

hiveTestApp::~hiveTestApp() {}

void
hiveTestApp::registerAll(Factory & f, ActionFactory & af, Syntax & s, bool use_test_objs)
{
  hiveApp::registerAll(f, af, s);
  if (use_test_objs)
  {
    Registry::registerObjectsTo(f, {"hiveTestApp"});
    Registry::registerActionsTo(af, {"hiveTestApp"});
  }
}

void
hiveTestApp::registerApps()
{
  registerApp(hiveApp);
  registerApp(hiveTestApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
// External entry point for dynamic application loading
extern "C" void
hiveTestApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  hiveTestApp::registerAll(f, af, s);
}
extern "C" void
hiveTestApp__registerApps()
{
  hiveTestApp::registerApps();
}
