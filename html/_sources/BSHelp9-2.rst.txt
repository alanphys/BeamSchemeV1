.. index::
   pair: Algorithms; In field area
   
In Field Area
=============

The In Field Area (IFA) refers to the flattened area of WFF beams. A number of varying definitions exist depending on the protocol. Practically these are very difficult to implement as they are usually only defined for certain profile angles and field sizes. An additional problem is that the IFA is often defined on the nominal field width in commercial systems which may be widely different from the actual field width.

BeamScheme has a sophisticated and extendible IFA algorithm. The IFA is implemented as a overlay or mask on the data. Data within the mask is processed. Data outside the mask is ignored. Current IFA types are

.. toctree::
   :maxdepth: 1

   BSHelp9-2-1.rst
   BSHelp9-2-2.rst
   BSHelp9-2-3.rst

The field statistics, flatness and symmetry values are all calculated from the IFA. For any discrepancies between values calculated by BeamScheme and other software first examine the defined in field area.

|Note| To view the IFA click or enable the :ref:`Show Parameters` button |params|

.. |Note| image:: _static/Note.png
.. |params| image:: _static/showparams.png
