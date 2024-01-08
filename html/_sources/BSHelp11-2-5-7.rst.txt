
.. index:: 
   single: Parameters; 1D Uniformity NCS

1D Uniformity NCS
=================

This is the maximum variation in the ratio of the absorbed dose at any point in the flattened area to that of the central axis expressed as a percentage difference between the lowest and highest value of this ratio according to NCS 70 eq 3-5.

.. math:: \cfrac {100} {cax} \cdot maximum \left[{|max - cax|}, {|min-cax|} \right ]
   
Where *max*, *min* and *cax* are the profile maximum, minimum and central axis values respectively.

**Protocol invocation name**: 1D Uniformity NCS

|Note| The *max*, *min* and *cax* are affected by :ref:`normalisation<Normalisation>` or windowing.

.. |Note| image:: _static/Note.png
