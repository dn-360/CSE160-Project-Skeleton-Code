#define AM_FLOOD 13
configuration FloodingC{
    provides interface Flooding;
}
implementation{
    components FloodingP;
    Flooding = FloodingP.Flooding;

    components new AMReceiverC(AM_FLOOD);
    FloodingP.FReceiver -> AMReceiverC;

    components new SimpleSendC(AM_FLOOD); 
    FloodingP.FSender -> SimpleSendC;

}