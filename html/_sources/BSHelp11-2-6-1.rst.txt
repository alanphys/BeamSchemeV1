
.. index:: 
   single: Parameter; 1D Symmetry Ratio

1D Symmetry Ratio
=================

The maximum dose ratio symmetry (also called the point difference quotient) is the maximum ratio between the left and right profile values at the same distance from the profile or detector centre taken over the :ref:`in field area<In Field Area>`:

.. math:: 100 \cdot maximum \left [\cfrac {P(dL)} {P(dR)} , \cfrac {P(dR)} {P(dL)} \right ]
   
for *dR* = -*dL* from the origin as defined by the array or imaging modality to the end of the in field area.

**Protocol invocation name**: 1D Symmetry Ratio

|Note| The ratio symmetry is affected by the field or detector centre. If the field is slightly offset you can use the Centre field tool |CentreField| to correct any offset.

.. |Note| image:: _static/Note.png

.. |CentreField| image:: _static/centre.png
