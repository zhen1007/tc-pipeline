kubectl apply -f tasks.yaml
kubectl apply -f pvc.yaml
kubectl apply -f pipeline.yaml

tkn pipeline start cd-pipeline \
    -w name=pipeline-workspace,claimName=pipelinerun-pvc \
    --showlog
