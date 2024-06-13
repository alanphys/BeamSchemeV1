
.. index:: 
   single: Parameters; 1D Penumbra Infl Right

1D Penumbra Infl Right
======================

The tradional parameters for defining the penumbra do not work for FFF beams. The similar 80%-20% penumbra based on the inflection point is calculated as the distance between 1.6 times the inflection point value to 0.4 times the inflection point value for the right penumbra.

.. math:: PenWidthINFL = |d(P_{0.4}) - d(P_{1.6})|

.. math:: P_{0.4} = Y_{infl} \cdot 0.4

.. math:: P_{1.6} = Y_{infl} \cdot 1.6

Where d(P :sub:`0.4`) and d(P :SUB:`1.6`)) are the linear distances to 0.4 and 1.6 times the inflection point value respectively as defined above.

**Protocol invocation name**: 1D Penumbra Infl Right


|Note| The profile must be centered on the origin as defined by the array or imaging modality for best results.

.. |Note| image:: _static/Note.png
