
.. index:: 
   single: Parameters; 1D Symmetry Diff

1D Symmetry Diff
================

The point difference (also called maximum variation) is the maximum absolute difference between the left and right profile values at the same distance from the profile or detector centre taken over the :ref:`in field area<In Field Area>`:

.. math:: 100 \cdot \cfrac {|P(dL) - P(dR)|} {cax}
   
for *dR* = -*dL* from 0 to the the edge of the :ref:`in field area<In Field Area>`.

**Protocol invocation name**: 1D Symmetry Diff

|Note| The point difference symmetry may be affected by the field or detector centre. If the field is slightly offset you can use the Centre field tool |CentreField| to correct any offset.

.. |Note| image:: _static/Note.png

.. |CentreField| image:: _static/centre.png
