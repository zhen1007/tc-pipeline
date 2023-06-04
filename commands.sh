tkn hub install task git-clone

kubectl apply -f https://raw.githubusercontent.com/tektoncd/catalog/main/task/git-clone/0.9/git-clone.yaml

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

tkn pipelinerun ls

tkn pipelinerun logs --last

kubectl get all -l app=tax-calculator
