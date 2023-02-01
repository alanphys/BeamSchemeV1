
.. index:: 
   single: Parameters; 1D Deviation Diff

1D Deviation Diff
=================

This is the maximum variation in the ratio of the absorbed dose at any point in the flattened area to that of the central axis expressed as a percentage difference between the lowest and highest value of this ratio.

.. math:: 100 \cdot maximum \left[\cfrac {|max - cax|} {cax}, \cfrac {|min-cax|} {cax} \right ]
   
Where *max*, *min* and *cax* are the profile maximum, minimum and central axis values respectively.

**Protocol invocation name**: 1D Deviation Diff

|Note| The *max*, *min* and *cax* are affected by :ref:`normalisation<Normalisation>` or windowing.

.. |Note| image:: _static/Note.png
