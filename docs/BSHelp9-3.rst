.. index::
   pair: Algorithms; Normalisation
   
Normalisation
=============

Normalisation is the scaling of data to defined limits, usually between 0 and 100. Normalisation in BeamScheme is visual and non-destructive, i.e. the underlying data is not changed. However, the normalisation affects the profile values and thus the parameters calculated from them. The normalisation is over the image and thus the profile maximum and minimum will not necessarily be 100 or 0 respectively. By default no normalisation is applied as it is assumed that the detector has been zeroed and calibrated.

Possible normalisation modes are:

.. toctree::
   :maxdepth: 1

   BSHelp8-2-2.rst
   BSHelp8-2-3.rst

|Note| The normalisation mode may affect parameter calculations

.. |Note| image:: _static/Note.png
