kubectl apply -f tasks.yaml
kubectl apply -f pvc.yaml
kubectl apply -f pipeline.yaml

tkn pipeline start cd-pipeline \
    -p repo-url="https://github.com/yahya-skillup/tax_calculator.git" \
    -p branch=main \
    -p app-name=tax-calculator \
    -p build-image=image-registry.openshift-image-registry.svc:5000/$SN_ICR_NAMESPACE/tekton-lab:latest \
    -w name=pipeline-workspace,claimName=pipelinerun-pvc \
    --showlog
