# nvidia-driver.yaml.template

Before using this template, you need to fix some values.

Run the following commands in your cluster to deploy the driver container:

**Be sure to replace `<DRIVER_VERSION>` with the desired driver version!**

```
DISTRIBUTION=$(. /etc/os-release; echo $ID$VERSION_ID)
DRIVER_VERSION=<DRIVER_VERSION>
curl -s -L -o nvidia-driver.yaml.template https://gitlab.com/nvidia/samples/raw/doc-6-6-2019/driver/kubernetes/nvidia-driver.yaml.template
envsubst < nvidia-driver.yaml.template > nvidia-driver.yaml
kubectl create -f nvidia-driver.yaml
```
