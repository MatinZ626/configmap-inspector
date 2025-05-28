# Description

A shell script for auditing ConfigMap usage across Kubernetes Deployments. It scans all namespaces (excluding kube-system, kube-public, and kube-node-lease) and identifies which ConfigMaps are referenced in each Deployment—either as volume mounts or environment variables.
The script outputs a readable report to output.txt listing each namespace along with its relevant ConfigMap → Deployment mappings.


# Let's Run it 

Install yq:
```bash
snap install yq
```
Clone the project: 
```bash
git clone https://github.com/MatinZ626/configmap-inspector.git
```
Dont forget permission:
```bash
chmod +x configmaptodeplo.sh
```
Now run it and see the result in output.txt
