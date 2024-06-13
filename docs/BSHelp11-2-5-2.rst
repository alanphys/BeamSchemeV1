
.. index:: 
   single: Parameters; 1D Flatness Diff

1D Flatness Diff
================

The flatness dose difference parameter is the normalised difference between the maximum and minimum profile values taken over the :ref:`in field area<In Field Area>`:

.. math:: 100 \cdot \cfrac {max-min} {max + min}
   
Where *max* and *min* are the profile maximum and minimum respectively.

**Protocol invocation name**: 1D Flatness Diff

|Note| The *max* and *min* may be affected by :ref:`normalisation<Normalisation>` or windowing.

.. |Note| image:: _static/Note.png
