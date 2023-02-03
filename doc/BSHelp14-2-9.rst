
.. index:: Protocol; All

All
===

The predefined protocol All contains every parameter implemented in BeamScheme. As this is a very long list users are encouraged to create their own parameter lists from this protocol by deleting what is not needed. This protocol should not be used regularly, but is included here for reference. The defined parameters are:

.. toctree::
   :maxdepth: 1

* 2D Image Stats
     * :ref:`CAX value<2D CAX Value>`
     * :ref:`Max value<2D Max Value>`
     * :ref:`Min value<2D Min Value>`
     * :ref:`Average<2D Ave Value>`
     * :ref:`Min IFA<2D Min IFA>`
     * :ref:`CoM (rowcol)<2D CoM Value>`
     * :ref:`CoM (XY)<2D CoM Scaled>`
     * Resolution
          * :ref:`X<2D X Res>`
          * :ref:`Y<2D Y Res>`
     * Detectors/Pixels
          * :ref:`X<2D X Pixels>`
          * :ref:`Y<2D Y Pixels>`
     * Size
          * :ref:`X<2D X Size>`
          * :ref:`Y<2D Y Size>`

* 2D Uniformity
     * :ref:`Uniformity NCS<2D Uniformity NCS-70>`
     * :ref:`Uniformity ICRU<2D Uniformity ICRU 72>`

* 2D Symmetry
     * :ref:`Symmetry<2D Symmetry NCS-70>`

* Profile stats
     * :ref:`CAX value<1D CAX Value>`
     * :ref:`Max value<1D Max Value>`
     * :ref:`Max pos<1D Max Pos>`
     * :ref:`Min value<1D Min Value>`
     * :ref:`Min IFA<1D Min IFA>`
     * :ref:`Average IFA<1D Average IFA>`

* Interpolated params
     * :ref:`Left edge<1D Field Edge Left 50>`
     * :ref:`Right edge<1D Field Edge Right 50>`
     * :ref:`Centre<1D Field Centre 50>`
     * :ref:`Size<1D Field Size 50>`
     * Penumbra
          * 80-20%
               * :ref:`Left<1D Penumbra 8020 Left>`
               * :ref:`Right<1D Penumbra 8020 Right>`
          * 90-10%
               * :ref:`Left<1D Penumbra 9010 Left>`
               * :ref:`Right<1D Penumbra 9010 Right>`
          * 90-50%
               * :ref:`Left<1D Penumbra 9050 Left>`
               * :ref:`Right<1D Penumbra 9050 Right>`

* Differential params
     * :ref:`Left edge<1D Left Diff>`
     * :ref:`Right edge<1D Right Diff>`
     * :ref:`Centre<1D Field Centre Diff>`
     * :ref:`Size<1D Field Size Diff>`

* Inflection params
     * :ref:`Left edge<1D Left Infl>`
     * :ref:`Right edge<1D Right Infl>`
     * :ref:`Centre<1D Field Centre Infl>`
     * :ref:`Size<1D Field Size Infl>`
     * Penumbra
          * :ref:`Left<1D Penumbra Infl Left>`
          * :ref:`Right<1D Penumbra Infl Right>`

* Dose point values
     * :ref:`Left 20% FW<1D Dose 20% FW Left>`
     * :ref:`Right 20% FW<1D Dose 20% FW Right>`
     * :ref:`Left 50% FW<1D Dose 50% FW Left>`
     * :ref:`Right 50% FW<1D Dose 50% FW Right>`
     * :ref:`Left 60% FW<1D Dose 60% FW Left>`
     * :ref:`Right 60% FW<1D Dose 60% FW Right>`
     * :ref:`Left 80% FW<1D Dose 80% FW Left>`
     * :ref:`Right 80% FW<1D Dose 80% FW Right>`

* Flatness
     * :ref:`Average<1D Flatness Ave>`
     * :ref:`Difference<1D Flatness Diff>`
     * :ref:`Ratio<1D Flatness Ratio>`
     * :ref:`CAX<1D Flatness CAX>`
     * :ref:`ICRU 72<1D Uniformity ICRU>`
     * :ref:`90/50<1D Flatness 9050>`

* Symmetry
     * :ref:`Ratio<1D Symmetry Ratio>`
     * :ref:`Difference<1D Symmetry Diff>`
     * :ref:`NCS-70<1D Symmetry Ave>`
     * :ref:`Area<1D Symmetry Area>`

* Deviation
     * :ref:`Ratio<1D Deviation Ratio>`
     * :ref:`Difference<1D Deviation Diff>`
     * :ref:`MAX/CAX<1D Deviation CAX>`



**Flattened field**

BeamScheme uses 80% of the :ref:`field size <1D Field Size 50>` as the flattened area.
