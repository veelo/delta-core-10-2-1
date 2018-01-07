delta-core-10-2-1
=================

 

Delta is a proof of concept to enhance the D Programming Language with the
Delphi ecosystem.

 

There are 2 scenarios Delta tries to achieve:

 

-   Create your GUI using the Delphi RAD Studio and connect the events with your
    logic written in D.  
    The obligatory Hello World sample:

    <https://github.com/andre2007/delta-fmx-10-2-1/tree/master/examples/gui1>

     

-   Use non visual Delphi components in your D code. For example you would be
    able to use the INDY (Internet Direct) components.

    In the sample application, the TTimer component is used. This example also
    shows how to write a wrapper component in D if the component is not already
    available.

    <https://github.com/andre2007/delta-fmx-10-2-1/tree/master/examples/ttimer>

     

How to start
------------

1.  Execute:

    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    git clone https://github.com/andre2007/delta-core-10-2-1.git
    dub add-local delta-core-10-2-1

    git clone https://github.com/andre2007/delta-fmx-10-2-1.git
    dub add-local delta-fmx-10-2-1
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

     

2.  Get free Delphi Starter Edition  
    <https://www.embarcadero.com/en/products/delphi/starter/free-download>

 

3.  Add “delta-core-10-2-1\\delphi” and “delta-fmx-10-2-1\\delphi” to your
    Delphi library path

 

4.  Load examples\\gui1\\views\\Project1.dpr in Delphi RAD Studio and build the
    project.  
    Project1.dll file will be created.

 

5.  Execute “dub” in folder examples\\gui1
