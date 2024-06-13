
.. index:: Parameters

Parameters
==========

BeamScheme v1.00+ features a completely rewritten parameter calculation engine.  Previously a linear search algorithm was used to calculate a series of base parameters from which the other parameters were derived. This was very efficient for single processors but encountered problems with non-linear parameters such as sigmoid fitting and could not be multithreaded for modern multiprocessor computers.

BeamScheme now calculates each parameter separately. This creates a very modular design and makes it easy to add new parameters. Where parameters calculations rely on other parameters the previous results are stored so parameters are only calculated once. Efficiencies are achieved by only calculating the parameters required by a :ref:`protocol<Protocols>`.

Calculation of 2D parameters is now possible. The same modular approach is used.

The calculation of parameters is affected by:

* :ref:`In Field Area`
* :ref:`Normalisation`
* :ref:`Centre Definition`

The following parameters are available for use in :ref:`protocols<Protocols>`. The protocol invocation name is the string by which the parameter is recognised in the protocol:

.. toctree::
   :maxdepth: 2

   BSHelp11-1.rst
   BSHelp11-2.rst
 
.. |Note| image:: _static/Note.png
