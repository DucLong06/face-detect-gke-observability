kubectl get secret elasticsearch-master-credentials -o jsonpath="{.data.username}" | base64 --decode

kubectl get secret elasticsearch-master-credentials -o jsonpath="{.data.password}" | base64 --decode