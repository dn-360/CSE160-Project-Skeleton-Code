
module FloodingP{
    provides interface Flooding;

    uses interface SimpleSend as FSender;
    uses interface Receive as FReceiver;

}
implementation{
    uint16_t src;
    uint16_t TTL = 10;
    uint16_t seqNum= 0;


    // command FReceiver.receive(message_t* msg, void* payload, uint8_t len){

    // }

    // command FSender.send(pack* msg, uint8_t dest){

    // }

}