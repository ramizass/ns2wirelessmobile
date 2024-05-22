# Introduction
Wireless networks consist of mobile nodes, which have the following characteristics: they have movement mechanisms, the ability to send and receive information through the channel while mobile, and they depend on their wireless environment [Mark Greiss]. Therefore, configuring a wireless network is different from configuring a wired network. The architecture of a mobile node in NS2 is an extension of the architecture of a regular node, where the mobile node is equipped with several network components, namely the link layer, interface queue, MAC layer, network interface with an antenna used to define the propagation model. These components are interconnected and connected to the channel. All these connections are shown in figure below

**Mobile Components**

![image](https://github.com/ramizass/ns2staticmobile/assets/88464165/bd597119-5a0c-4903-816f-9308f06ef35c)

Generally, the network components used to configure a mobile node include:

1. Channel Type (chan): This is the channel type for the media used to send and receive information packets. By default, a Wireless Channel is provided.
2. Network Interface (Netif): This is the interface between the MAC Layer and the Physical Layer, in this case, the Channel. By default, Wireless Phy is provided.
3. Radio Propagation Model: The available radio propagation type is TwoRay Ground, where the attenuation at a long distance is 1/r^4, with r being the distance from the transmitter to the receiver.
4. Medium Access Control (MAC) Protocol: NS2 uses IEEE 802.11 for this MAC protocol.
5. Adhoc Routing Protocol: There are 5 adhoc routing protocols that support NS2, namely DSDV (Destination Sequence Distance Vector), DSR (Dynamic Source Routing), TORA (Temporally Ordered Routing Algorithm), AODV (Adhoc On Demand Distance Vector), and PUMA (Protocol for Unified Multicasting through Announcement).
6. Interface Queue (ifq): NS2 provides PriQueue, which is an interface that gives priority for routing protocol packets, adding these packets to the head of the queue. The implementation of this interface queue is in /ns-2/priqueue.h and priqueue.cc.
7. Link Layer (LL): In NS2, the LL used has an ARP (Address Resolution Protocol) module that converts all IPs to hardware MAC addresses. Usually, all outgoing packets are carried to the LL by the Routing Agent, and then the LL brings these packets to the ifq. For incoming packets, the MAC layer carries them to the LL, and the LL forwards them to the entry node. The LL in NS2 is in /tcl/lan/ns-ll.tcl.
8. Topography Object (topo): This component defines the topology of the designed wireless network, in the form of a topography.
9. Antenna Type (ant): The type of antenna provided is an omnidirectional antenna, which has a 360-degree radiation pattern with a gain of 1. The definition of this antenna is in ns2/antenna.cc and antenna.h.

Another difference between configuring a wireless network and a wired network is the presence of GOD (General Operations Director). GOD is an object used to store global information about the environment, network, or nodes. Typically, the GOD object stores the total number of mobile nodes and a table of the shortest hop count required from the source node to the destination.

# Simulation Scenario
A wireless network consists of 2 mobile nodes (n0, n1). These two nodes are placed at the following coordinates: n0 =(5,2,0) and n1=(390,385,0). The nodes are spread over an area of 500x500 square meters. Node n0 sends FTP packets via TCP to node n1. The network simulation will be as follows:
1. At the 2-second mark, node (0) will move to coordinates (100,40,0) at a speed of 25 m/s.
2. At the 4-second mark, node (1) will move to coordinates (300,18,0) at a speed of 40 m/s.
3. At the 10-second mark, node (1) will move to coordinates (490,480,0) at a speed of 20 m/s.
4. The FTP packet transmission from n0 to n1 starts at the 4-second mark and ends at the 10-second mark.
5. The simulation ends at 20.0001 seconds.
