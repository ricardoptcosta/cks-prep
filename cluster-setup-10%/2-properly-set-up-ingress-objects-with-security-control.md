# What is ingress

## What is the difference between Load Balancer and Ingress

It's a 4th way of exposing pods, but it's not a service. it addresses a limitation of a load balancer type service which is every load balancer service requires its own load balancer. If one has many services one needs many load balancers which is wasteful. In contrast, an ingress works like a reverse proxy and can be shared among any number of services (using their clusterips) via rules
