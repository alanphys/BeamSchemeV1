.. index:: Parameters; 2D Uniformity NCS-70

2D Uniformity NCS-70
====================

Returns the maximum difference between the max and CAX value and the min
and CAX value of the IFA normalised to CAX according to NCS-70 eq 3-5.

.. math::  maximum \left[ {max - cax} , {min - cax} \right ] \cdot \cfrac {100} {cax}

Where *max*, *min* and *cax* are the profile maximum, minimum and central axis values respectively.

**Protocol invocation name**: 2D Uniformity NCS-70

|Note| The *max*, *min* and *cax* are affected by the set window levels.

.. |Note| image:: _static/Note.png
