
.. index:: 
   single: Parameters; 1D Flatness Ave

1D Flatness Ave
===============

The average value dose parameter is the normalised average between the maximum and minimum profile values taken over the :ref:`in field area<In Field Area>`:

.. math:: \cfrac {100} {cax} \cdot \cfrac {max + min} {2}
   
Where *max* and *min* are the profile maximum and minimum respectively and *cax* is the profile centre value.

**Protocol invocation name**: 1D Flatness Ave

|Note| The *max*, *min* and *cax* may be affected by :ref:`normalisation<Normalisation>` or windowing.

.. |Note| image:: _static/Note.png
