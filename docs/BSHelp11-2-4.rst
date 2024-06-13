.. index::
   single: Parameters; Inflection point

Inflection Point Parameters
===========================

For FFF beams the standard interpolated or dose level parameters do not give good results. The field edge of FFF beams is defined at the inflection point of the penumbra. For low resolution measuring devices like 2D arrays this can be quite inaccurate. Therefore a sigmoid model is fitted to the penumbra using a Hill function:

.. math:: f(x) = A + \cfrac {B - A} {1 + \left (\cfrac {C} {x} \right)^D}

where:
   * A: sigmoid low level
   * B: sigmoid high level
   * C: approximate inflection point
   * D: slope of the sigmoid
   
The inflection point is determined from:

.. math:: x = C \cdot \left ( \cfrac {D - 1} {D + 1} \right )^{\cfrac {1} {D}}

Once the regression parameters have been determined the inverse Hill function can be used to determine other parameters around the inflection point:

.. math:: x = C \cdot \left ( \cfrac {f(x) - A} {B - f(x)} \right )^{\cfrac {1} {D}}

The algorithm selects 20 points around the maximum slope in the penumbra. For high resolution detectors these points may be within the penumbra, but for low resolution detectors there may not be enough points to fulfil this requirement and the selected points will extend from the start (or end) of the profile to the middle.

|Note| If the penumbra is not well formed the non-linear regression will fail and the results returned will be 0.

.. toctree::
   :maxdepth: 2
   
   BSHelp11-2-4-1.rst
   BSHelp11-2-4-2.rst
   BSHelp11-2-4-3.rst
   BSHelp11-2-4-4.rst
   BSHelp11-2-4-5.rst
   BSHelp11-2-4-6.rst
   BSHelp11-2-4-15.rst
   BSHelp11-2-4-7.rst
   BSHelp11-2-4-8.rst
   BSHelp11-2-4-9.rst
   BSHelp11-2-4-10.rst
   BSHelp11-2-4-11.rst
   BSHelp11-2-4-12.rst
   BSHelp11-2-4-13.rst
   BSHelp11-2-4-14.rst

.. |Note| image:: _static/Note.png
