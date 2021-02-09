// #include <Timer.h>
// #include "../../includes/CommandMsg.h"
// #include "../../includes/packet.h"

configuration NeighborDiscoveryC{
    provides interface NeighborDiscovery;
    uses interface Hashmap<pack> as NHashmapC;
}
implementation{
    
    components NeighborDiscoveryP;
    NeighborDiscovery = NeighborDiscoveryP.NeighborDiscovery;

    NeighborDiscoveryP.NHashmap = NHashmapC;

    components new TimerMilliC() as PeriodicTimer;
    NeighborDiscoveryP.PeriodicTimer -> PeriodicTimer; // Timer to send neighbor dircovery packets periodically

    components new AMReceiverC(AM_PACK);
    NeighborDiscoveryP.NReceiver -> AMReceiverC;

    components new SimpleSendC(AM_PACK); 
    NeighborDiscoveryP.NSender -> SimpleSendC;

    components RandomC as RandomTimer;
    NeighborDiscoveryP.RandomTimer -> RandomTimer;
    
    
}