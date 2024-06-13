.. index:: 
   single: Parameters; 1D Field Edge Right 50

1D Field Edge Right 50
======================

Linear distance from the central axis as defined by the array or imaging modality to the point on the right side of the displayed profile where the dose profile drops below 50% of the central axis dose. If this point lies between two measured values the distance is linearly interpolated. This is the traditional field edge for flattened beams.

Since version 0.5 BeamScheme no longer does automatic grounding of the profile, i.e. reducing the minimum to zero. This means that if you want the grounded field size you must *explicitly* normalise or window the image.

**Protocol invocation name**: 1D Field Edge Right 50

|Note| Noisy data can lead to a reduced field edge value being reported.

.. |Note| image:: _static/Note.png
