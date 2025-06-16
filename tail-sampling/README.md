# This is a tail sampling example setup

## Setup

This setup demonstrates tail sampling.<br/>
The OpenTelemetry Demo sends the otlp tracing data over http to Traefik.<br/>
Traefik sends it to the LB collector. The headless services makes sure that both LB's are used.<br/>
The LB collector must have a service account to be able to resolve the ip's of the TS collectors.<br/>

## Run
To bring up the stack:<br/>
./up.sh apps

Then start demo:
cd demo
./up.sh

To bring down the stack:<br/>
./down.sh apps

```
                      +------------------+
                      |  Demo Collector  |
                      |  (sends OTLP)    |
                      +--------+---------+
                               |
                               v
                        +-------------+
                        |   Traefik   |
                        | (ingress)   |
                        +------+------+ 
                               |
                               v
        +--------------------------------------------+
        |   Collector Headless Service (Load Balancer)  |
        +--------------------+--------------------------+
                             |
         +------------------+------------------+
         |                                     |
         v                                     v
+--------------------+             +--------------------+
| LB Collector #1    |             | LB Collector #2    |
+---------+----------+             +----------+---------+
          \                            /
           \                          /
            \                        /
             \                      /
              \                    /
               \                  /
                v                v
              +----+          +----+          +----+
              | TS |          | TS |          | TS |
              | #1 |          | #2 |          | #3 |
              +----+          +----+          +----+

TS = Tail Sampling Collector
```
