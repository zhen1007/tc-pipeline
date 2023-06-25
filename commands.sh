tkn hub install task git-clone -n sn-labs-muhammady
tkn hub install task docker-build -n sn-labs-muhammady
tkn hub install task ibmcloud -n sn-labs-muhammady

tkn task start ibmcloud 


tkn clustertask ls

kubectl apply -f https://raw.githubusercontent.com/tektoncd/catalog/main/task/git-clone/0.9/git-clone.yaml
kubectl apply -f https://api.hub.tekton.dev/v1/resource/tekton/task/ibmcloud/0.1/raw

kubectl apply -f tasks.yaml
kubectl apply -f pvc.yaml
kubectl apply -f secret.yaml
kubectl apply -f serviceaccount.yaml
kubectl apply -f pipeline.yaml
kubectl apply -f run.yaml

tkn pipeline start cd-pipeline \
    -p repo-url="https://github.com/yahya-skillup/tax_calculator.git" \
    -p branch=main \
    -p app-name=tax-calculator \
    -p build-image=image-registry.openshift-image-registry.svc:5000/$SN_ICR_NAMESPACE/tax-calculator \
    -w name=pipeline-workspace,claimName=pipelinerun-pvc \
    --showlog

tkn pipelinerun ls

tkn pipelinerun logs --last

kubectl get all -l app=tax-calculator



IBMCLOUD_API_KEY=THE_KEY
ibmcloud login --apikey $IBMCLOUD_API_KEY
ibmcloud target -g production
ibmcloud ce project current | grep ID | awk '{split($2, a, ":"); print a[1]}'
ibmcloud ce project current | grep Region | awk '{split($2, a, ":"); print a[1]}'
ibmcloud ce project select --id d8db2fbf-REMAINING_ID
ibmcloud ce project current

ibmcloud ce application delete --name tax-calculator  -f

tkn pipeline start cd-pipeline \
    -p repo-url="https://github.com/yahya-skillup/tax_calculator.git" \
    -p branch=main \
    -p app-name=tax-calculator \
    -p build-image=us.icr.io/${SN_ICR_NAMESPACE}/tax-calculator \
    -p ibmcloud-api-key="$IBMCLOUD_API_KEY" \
    -p ibmcloud-region=us-south \
    -p ibmcloud-project-id= 199ccf6d-79b9-4d60-95f7-e26052736f50 \
    -w name=pipeline-workspace,claimName=pipelinerun-pvc \
    -n sn-labs-muhammady \
    --showlog

#     -p build-image=image-registry.openshift-image-registry.svc:5000/$SN_ICR_NAMESPACE/tax-calculator \
