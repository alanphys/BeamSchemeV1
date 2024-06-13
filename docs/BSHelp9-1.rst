.. index::
   pair: Algorithms; FFF
   
FFF algorithms
==============

For FFF beams the standard interpolated or dose level parameters do not give good results. FFF fields are sharply peaked and the FWHM (50% dose level) is not a good indicator of the collimator field size. For FFF beams the inflection point (the point where the slope of the penumbra is greatest) of the penumbra has been proposed to represent the field edge.

While the maximum slope of the penumbra can be calculated directly by :ref:`differentiation<1D Differential Parameters>` this can be quite inaccurate for low resolution detectors such as 2D arrays and the recommended method is to fit a sigmoid or Hill function to the penumbra data and determine the inflection point of the function.

This is described under :ref:`Inflection Point Parameters`
