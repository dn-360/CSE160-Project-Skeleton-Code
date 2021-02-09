//header from Node (using the same implementation ping to ping)
#include <Timer.h>
#include "../../includes/command.h"
#include "../../includes/packet.h"
#include "../../includes/channels.h"
#include "../../includes/neighbor.h"
#include "../../includes/protocol.h"

#define NEIGHBORHOOD_SIZE 19; //how many nodes do we need?
#define TIMEOUT 10; //what is a good timeout?

module NeighborDiscoveryP{
    provides interface NeighborDiscovery;

    uses interface Timer<TMilli> as PeriodicTimer;
    uses interface SimpleSend as NSender;
    uses interface Receive as NReceiver;
    uses interface Random as RandomTimer;
   //  uses interface List<neighbor> as NeighborList;

}
implementation{

    pack sendPackage;

    uint16_t seqCount = 0; //Start sequence at 0 and increase by 1 every hop
    uint32_t timer0;

    // Prototypes
   void makePack(pack *Package, uint16_t src, uint16_t dest, uint16_t TTL, uint16_t Protocol, uint16_t seq, uint8_t *payload, uint8_t length);
   void updateNeighbors(); //Updates active and inactive neighbors
   void discoverNeighbors(); // 

   command void NeighborDiscovery.start(){ //command called after node booted
    dbg(NEIGHBOR_CHANNEL, "Neighbor discovery module works!\n");
    timer0 = (1000 + (uint32_t)((call RandomTimer.rand32())%1000));
    call PeriodicTimer.startOneShot(timer0);

   }

   command void NeighborDiscovery.print(){
      dbg(NEIGHBOR_CHANNEL, "Print neighbors found here\n");
      return;
   }

   event void PeriodicTimer.fired()
   {
     discoverNeighbors();
   }



   pack* myMsg; //why only works if outside of the function?
   
   event message_t* NReceiver.receive(message_t* msg, void* payload, uint8_t len){ 
      dbg(NEIGHBOR_CHANNEL, "Packet Received\n");
      myMsg=(pack*) payload;
      if(myMsg->dest == AM_BROADCAST_ADDR){ //if message destiny reaches its final destination
         dbg(NEIGHBOR_CHANNEL, "msg->dest == AM_BROADCAST_ADDR worked %s\n", myMsg->payload);
         return msg;
      }
      dbg(NEIGHBOR_CHANNEL, "Unknown Packet Type %d\n", len);
      return msg;
   }

   void discoverNeighbors(){
       dbg(NEIGHBOR_CHANNEL, "Timer fired: Searching for neighbors...\n");
       makePack(&sendPackage, TOS_NODE_ID, AM_BROADCAST_ADDR, 0, 0, PROTOCOL_PING, "test", PACKET_MAX_PAYLOAD_SIZE);
       call NSender.send(sendPackage, sendPackage.dest);
    //    updateNeighbors();

   }

   void makePack(pack* Packet, uint16_t src, uint16_t dest, uint16_t TTL, uint16_t protocol, uint16_t seq, uint8_t* payload, uint8_t length)
   {
       Packet->src = src;
      Packet->dest = dest;
      Packet->TTL = TTL;
      Packet->seq = seq;
      Packet->protocol = protocol;
      memcpy(Packet->payload, payload, length);
   }

}