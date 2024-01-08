.. index:: 
   single: Parameters; 1D Left Diff

1D Left Diff
=====================

Linear distance from the central axis as defined by the array or imaging modality to the point on the left side of the displayed profile where the profile slope is maximum. Also known as the point of maximum gradient. The maximum slope is found by calculating the first derivative and finding the maximum value. No interpolation is performed so this method is inaccurate for low resolution detectors such as 2D arrays.

**Protocol invocation name**: 1D Left Diff

|Note| Noisy data can lead to a reduced field edge value being reported.

.. |Note| image:: _static/Note.png
