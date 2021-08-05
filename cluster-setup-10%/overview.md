# Use Network security policies to restrict cluster level access
## What are network security policies?
Network policies allow or block traffic between pods, from outside cluster
```yaml
kind: NetworkPolicy
metadata:
  name: np1
  namespace: ns1
spec:
  podSelector:
    matchLabels:
      role: frontend
  policyTypes:
    - Ingress
    - Egress
  ingress:
    - from:
      - ipBlock:
          cidr: 172.17.0.0/16
          except:
          - 172.17.1.0/24
      - namespaceSelector:
          matchLabels:
            project: myproject
      - podSelector:
          matchLabels:
            role: frontend
  egress:

```

By default pods can talk to all other pods. As soon as a network policy exists, it is enforced. To deny all, simply create a np that doesn't select anything. 

Network policies are additive, ie, they make traffic restrictions more and more restrictive as they are added. In the above yaml, pods with labels role=frontend can only receive ingress traffic from pods in ipBlock xxx AND namespaces with label project=myproject AND with label role=frontend
















# Use CIS benchmark to review the security configuration of Kubernetes components (etcd, kubelet, kubedns, kubeapi)

# Properly set up Ingress objects with security control

# Protect node metadata and endpoints

# Minimize use of, and access to, GUI elements

# Verify platform binaries before deploying
