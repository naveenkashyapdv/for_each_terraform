


************************************************************************
Using Modules
************************************************************************

1. To use a module from this repository, add a block like the following to
   your terraform code:

   .. code-block:: hcl

        module "cool_thing" {
          source = source = "git::ssh://git@gitlab.com/some_module.git/?ref=v1.0"
          var_one = "foo"
          var_two = "bar"
        }

#. Ensure that the ``ref`` above corresponds to an existing release tag in this repository.

#. The modules are broken into Envirornments, please choose correctly.

#. Anything after the ``//`` is the enviroment path.

#. Run ``terraform get`` to acquire the module.

#. Wining! You can now run ``terraform plan`` to see how it will work.
