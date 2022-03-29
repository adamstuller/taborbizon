rsync -avh --progress \
    -e "ssh -i taborbizon.pem" \
    --delete --delete-excluded \
    --exclude-from='rsync-exclude' \
    ../ ec2-user@ec2-54-82-42-238.compute-1.amazonaws.com:taborbizon