#define AM_NEIGHBOR 62;

configuration NeighborDiscoveryC{
    provides interface NeighborDiscovery;
}
implementation{

    components NeighborDiscoveryP;
    NeighborDiscovery = NeighborDiscoveryP.NeighborDiscovery;

    components new TimerMilliC() as PeriodicTimer;
    NeighborDiscoveryP.PeriodicTimer -> PeriodicTimer; // Timer to send neighbor dircovery packets periodically

    components new AMReceiverC(AM_NEIGHBOR); 
    NeighborDiscoveryP.NReceiver -> AMReceiverC;

    components new SimpleSendC(AM_NEIGHBOR); 
    NeighborDiscoveryP.NSender -> SimpleSendC;

    components new RandomC as RandomTimer;
    NeighborDiscoveryP.RandomTimer -> RandomTimer;
    
    
}