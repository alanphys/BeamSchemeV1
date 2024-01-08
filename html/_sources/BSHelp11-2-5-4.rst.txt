
.. index:: 
   single: Parameters; 1D Flatness CAX

1D Flatness CAX
===============

This is the average between the maximum and minimum profile values taken over the :ref:`in field area<In Field Area>` normalised to CAX:

.. math:: \cfrac {100} {cax} \cdot \cfrac {max - min} {2}
   
Where *max* and *min* are the profile maximum and minimum respectively and *cax* is the profile centre value.

**Protocol invocation name**: 1D Flatness CAX

|Note| The *max*, *min* and *cax* may be affected by :ref:`normalisation<Normalisation>` or windowing.

.. |Note| image:: _static/Note.png
