# From https://course.fast.ai/start_gcp.html
# step 3

set-variable -name IMAGE_FAMILY -value "pytorch-latest-gpu"
set-variable -name ZONE -value "europe-west4-b"
set-variable -name INSTANCE_NAME -value "fastai-instance-1"
set-variable -name INSTANCE_TYPE -value "n1-highmem-8"

gcloud compute instances create $INSTANCE_NAME --zone=$ZONE `
    --image-family=$IMAGE_FAMILY --image-project="deeplearning-platform-release" `
    --maintenance-policy='TERMINATE' --accelerator="type=nvidia-tesla-p4,count=1" `
    --machine-type=$INSTANCE_TYPE --boot-disk-size="200GB" --metadata="install-nvidia-driver=True" `
    --preemptible
