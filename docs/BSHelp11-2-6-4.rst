
.. index:: 
   single: Parameters; 1D Symmetry Area

1D Symmetry Area
================

The area symmetry is the normalised difference between the right and left areas under the profile up to the  :ref:`right<1D Field Edge Left 50>` and :ref:`left<1D Field Edge Right 50>` field edges:

.. math:: 100 \cdot \cfrac {RA-LA} {RA + LA}
   
Where *RA* and *LA* are the areas under the profile from the field centre to the :ref:`right<1D Field Edge Left 50>` and :ref:`left<1D Field Edge Right 50>` field edge respectively.

**Protocol invocation name**: 1D Symmetry Area

|Note| In contrast with other symmetry calculations the area symmetry is not affected by the detector centre.

|Note| Some commercial programs use a mulitplicative factor of 200.

.. |Note| image:: _static/Note.png
