.. index:: Parameters; 2D Uniformity Differential

2D Uniformity Differential
==========================

Returns the maximum difference between the max and the min of the :ref:`In Field Area`  for any five contiguous pixels normalised to the sum of the min and max according to IAEA pub 1394 section 2.3.3 eq 3.

.. math:: {\cfrac {(max-min)} {(max+min)}} \cdot {100}

Where *max* and *min* are the IFA maximum and minimum respectively and *ave* is the average value of the IFA.

**Protocol invocation name**: 2D Uniformity Differential

|Note| The *max* and *min* may be affected by the set window levels. No smoothing or pixel summation is done.

.. |Note| image:: _static/Note.png
